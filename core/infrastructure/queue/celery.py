"""Celery-backed queue implementation."""

from __future__ import annotations

from datetime import datetime, timezone
import logging
from uuid import uuid4

from typing import Any

from celery import Celery

from core.infrastructure.exceptions import QueueError
from core.infrastructure.serializers.json import JSONBackgroundSerializer
from core.infrastructure.queue.base import QueueMessage

logger = logging.getLogger(__name__)


class CeleryQueueBackend:
    """Publish-only queue backend backed by Celery and Redis."""

    def __init__(
        self,
        *,
        app: Celery,
        task_name: str,
        queue_name: str,
        serializer: JSONBackgroundSerializer | None = None,
        default_retry_delay_seconds: int = 5,
        max_retries: int = 5,
    ) -> None:
        self._app = app
        self._task_name = task_name
        self._queue_name = queue_name
        self._serializer = serializer or JSONBackgroundSerializer()
        self._default_retry_delay_seconds = default_retry_delay_seconds
        self._max_retries = max_retries

    def publish(self, payload: object, *, delay_seconds: int = 0) -> str:
        message_id = str(payload.get("job_id")) if isinstance(payload, dict) and payload.get("job_id") else str(uuid4())
        now = datetime.now(timezone.utc)
        if not isinstance(payload, dict):
            raise QueueError("Celery background jobs require a JSON object payload.")

        message_payload = dict(payload)
        message_payload.setdefault("message_id", message_id)
        try:
            encoded = self._serializer.dumps(message_payload)
            self._app.send_task(
                self._task_name,
                args=[encoded],
                task_id=message_id,
                queue=self._queue_name,
                serializer="json",
                retry=True,
                retry_policy={
                    "max_retries": self._max_retries,
                    "interval_start": self._default_retry_delay_seconds,
                    "interval_step": self._default_retry_delay_seconds,
                    "interval_max": self._default_retry_delay_seconds * 6,
                },
                countdown=delay_seconds or None,
            )
            logger.info(
                "task_submitted",
                extra={
                    "task_id": message_id,
                    "queue": self._queue_name,
                    "task_name": self._task_name,
                    "delay_seconds": delay_seconds,
                },
            )
            print(
                f"[STT] celery_send_task task_id={message_id} queue={self._queue_name} "
                f"task={self._task_name}",
                flush=True,
            )
            return message_id
        except Exception as exc:  # pragma: no cover - exercised via tests with mocks
            logger.exception("queue_unavailable", extra={"task_name": self._task_name, "queue": self._queue_name})
            raise QueueError(str(exc)) from exc

    def consume(self, max_messages: int = 1, timeout_seconds: int | None = None) -> list[QueueMessage]:
        return []

    def acknowledge(self, message_id: str) -> None:
        logger.debug("task_acknowledged", extra={"task_id": message_id, "queue": self._queue_name})

    def reject(self, message_id: str, requeue: bool = False) -> None:
        logger.debug(
            "task_rejected",
            extra={"task_id": message_id, "queue": self._queue_name, "requeue": requeue},
        )

    def retry(self, message_id: str, delay_seconds: int = 0) -> None:
        logger.warning(
            "task_retry_requested",
            extra={
                "task_id": message_id,
                "queue": self._queue_name,
                "delay_seconds": delay_seconds or self._default_retry_delay_seconds,
            },
        )

    def delay(self, payload: object, delay_seconds: int) -> str:
        return self.publish(payload, delay_seconds=delay_seconds)

    def schedule(self, payload: object, run_at: datetime) -> str:
        now = datetime.now(timezone.utc)
        delay_seconds = max(0, int((run_at - now).total_seconds()))
        return self.publish(payload, delay_seconds=delay_seconds)
