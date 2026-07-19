"""Generic background job dispatcher."""

from __future__ import annotations

import logging
from dataclasses import dataclass
from datetime import datetime, timezone
from socket import gethostname
from typing import Any

from core.infrastructure.exceptions import (
    BackendNotRegisteredError,
    BackgroundJobPermanentError,
    BackgroundJobRetryableError,
    SerializationError,
)
from core.infrastructure.jobs.bootstrap import ensure_default_handlers
from core.infrastructure.jobs.registry import handler_registry
from core.infrastructure.jobs.states import BackgroundJobRecord, JobStatus
from core.infrastructure.jobs.status_store import DurableBackgroundJobStatusStore
from core.infrastructure.serializers.json import JSONBackgroundSerializer

logger = logging.getLogger(__name__)


@dataclass(frozen=True, slots=True)
class BackgroundJobEnvelope:
    job_id: str
    handler_name: str
    payload: dict[str, Any]
    participation_id: int | None = None
    message_id: str | None = None
    queue: str | None = None
    correlation_id: str | None = None


class BackgroundJobDispatcher:
    def __init__(
        self,
        *,
        status_store: DurableBackgroundJobStatusStore | None = None,
        serializer: JSONBackgroundSerializer | None = None,
    ) -> None:
        self._status_store = status_store or DurableBackgroundJobStatusStore()
        self._serializer = serializer or JSONBackgroundSerializer()

    def dispatch(self, raw_message: str) -> Any:
        ensure_default_handlers()
        try:
            data = self._serializer.loads(raw_message)
        except SerializationError:
            logger.exception("serialization_failed", extra={"message_id": None})
            raise

        try:
            envelope = BackgroundJobEnvelope(**data)
        except Exception as exc:
            logger.exception("invalid_payload", extra={"payload": data})
            raise SerializationError(str(exc)) from exc

        started_at = datetime.now(timezone.utc)
        print(
            f"[STT] dispatcher_started job_id={envelope.job_id} "
            f"participation_id={envelope.participation_id} handler={envelope.handler_name}",
            flush=True,
        )
        self._status_store.update(
            envelope.job_id,
            status=JobStatus.RUNNING,
            started_at=started_at,
            message_id=envelope.message_id,
            celery_task_id=envelope.message_id,
            queue=envelope.queue,
            correlation_id=envelope.correlation_id or envelope.job_id,
            worker_hostname=gethostname(),
        )
        self._sync_participation_status(envelope.participation_id, "running")
        logger.info(
            "dispatcher_started",
            extra={
                "job_id": envelope.job_id,
                "message_id": envelope.message_id,
                "participation_id": envelope.participation_id,
                "handler_name": envelope.handler_name,
                "queue": envelope.queue,
                "worker_hostname": gethostname(),
                "correlation_id": envelope.correlation_id or envelope.job_id,
            },
        )
        try:
            handler = handler_registry.resolve(envelope.handler_name)
        except BackendNotRegisteredError as exc:
            self._status_store.update(envelope.job_id, status=JobStatus.FAILED, finished_at=datetime.now(timezone.utc), last_error=str(exc))
            self._sync_participation_status(envelope.participation_id, "failed")
            logger.exception(
                "unknown_handler",
                extra={"job_id": envelope.job_id, "handler_name": envelope.handler_name, "queue": envelope.queue},
            )
            raise

        try:
            result = handler.handle(envelope.payload)
            self._status_store.update(
                envelope.job_id,
                status=JobStatus.SUCCESS,
                finished_at=datetime.now(timezone.utc),
            )
            print(
                f"[STT] dispatcher_finished SUCCESS job_id={envelope.job_id} "
                f"participation_id={envelope.participation_id}",
                flush=True,
            )
            logger.info(
                "dispatcher_finished",
                extra={
                    "job_id": envelope.job_id,
                    "message_id": envelope.message_id,
                    "participation_id": envelope.participation_id,
                    "handler_name": envelope.handler_name,
                    "queue": envelope.queue,
                    "worker_hostname": gethostname(),
                    "correlation_id": envelope.correlation_id or envelope.job_id,
                },
            )
            return result
        except BackgroundJobRetryableError as exc:
            record = self._status_store.get(envelope.job_id)
            next_retry_count = (record.retry_count if record is not None else 0) + 1
            self._status_store.update(
                envelope.job_id,
                status=JobStatus.RETRYING,
                finished_at=datetime.now(timezone.utc),
                last_error=str(exc),
                retry_count=next_retry_count,
            )
            self._sync_participation_status(envelope.participation_id, "retrying")
            logger.warning(
                "retry_scheduled",
                extra={
                    "job_id": envelope.job_id,
                    "message_id": envelope.message_id,
                    "participation_id": envelope.participation_id,
                    "handler_name": envelope.handler_name,
                    "queue": envelope.queue,
                    "worker_hostname": gethostname(),
                    "correlation_id": envelope.correlation_id or envelope.job_id,
                    "retry_count": next_retry_count,
                },
            )
            raise
        except BackgroundJobPermanentError as exc:
            self._status_store.update(
                envelope.job_id,
                status=JobStatus.FAILED,
                finished_at=datetime.now(timezone.utc),
                last_error=str(exc),
            )
            self._sync_participation_status(envelope.participation_id, "failed")
            logger.exception(
                "task_failed",
                extra={
                    "job_id": envelope.job_id,
                    "message_id": envelope.message_id,
                    "participation_id": envelope.participation_id,
                    "handler_name": envelope.handler_name,
                    "queue": envelope.queue,
                    "worker_hostname": gethostname(),
                    "correlation_id": envelope.correlation_id or envelope.job_id,
                },
            )
            raise
        except Exception as exc:
            self._status_store.update(
                envelope.job_id,
                status=JobStatus.FAILED,
                finished_at=datetime.now(timezone.utc),
                last_error=str(exc),
            )
            self._sync_participation_status(envelope.participation_id, "failed")
            logger.exception(
                "task_failed",
                extra={
                    "job_id": envelope.job_id,
                    "message_id": envelope.message_id,
                    "participation_id": envelope.participation_id,
                    "handler_name": envelope.handler_name,
                    "queue": envelope.queue,
                    "worker_hostname": gethostname(),
                    "correlation_id": envelope.correlation_id or envelope.job_id,
                },
            )
            raise

    @staticmethod
    def _sync_participation_status(participation_id: int | None, status: str) -> None:
        if participation_id is None:
            return
        from users.models import Participation

        Participation.objects.filter(id=participation_id).exclude(
            status__in=("user_review", "approved", "rejected")
        ).update(status=status)
