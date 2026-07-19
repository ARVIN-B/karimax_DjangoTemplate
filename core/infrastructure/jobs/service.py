"""Application-facing background job service."""

from __future__ import annotations

from datetime import datetime, timezone
from uuid import uuid4

from core.infrastructure.factory import QueueFactory
from core.infrastructure.exceptions import QueueError
from core.infrastructure.jobs.states import BackgroundJobRecord, JobStatus
from core.infrastructure.jobs.status_store import DurableBackgroundJobStatusStore


def enqueue_transcription_job(*, participation_id: int, handler_name: str = "transcription") -> str:
    print(
        f"[STT] enqueue_transcription_job start participation_id={participation_id}",
        flush=True,
    )
    queue = QueueFactory.create()
    status_store = DurableBackgroundJobStatusStore()
    created_at = datetime.now(timezone.utc)
    job_id = str(uuid4())
    status_store.save(
        BackgroundJobRecord(
            job_id=job_id,
            participation_id=participation_id,
            status=JobStatus.PENDING,
            created_at=created_at,
            handler_name=handler_name,
            queue=getattr(queue, "_queue_name", None),
            correlation_id=job_id,
        )
    )
    job_payload = {
        "job_id": job_id,
        "handler_name": handler_name,
        "participation_id": participation_id,
        "correlation_id": job_id,
        "payload": {"participation_id": participation_id, "job_id": job_id},
    }
    try:
        queue.publish(job_payload)
        status_store.update(job_id, status=JobStatus.WAITING, message_id=job_id, celery_task_id=job_id)
        print(
            f"[STT] enqueue_transcription_job published job_id={job_id} participation_id={participation_id}",
            flush=True,
        )
    except QueueError as exc:
        print(
            f"[STT] enqueue_transcription_job FAILED job_id={job_id} error={exc}",
            flush=True,
        )
        status_store.update(job_id, status=JobStatus.FAILED, last_error=str(exc))
        _mark_participation_failed(participation_id)
        raise
    return job_id


def _mark_participation_failed(participation_id: int) -> None:
    from users.models import Participation

    Participation.objects.filter(id=participation_id).exclude(
        status__in=("user_review", "approved", "rejected")
    ).update(status="failed")


def get_retry_delay_seconds(retry_number: int) -> int:
    from core.infrastructure.settings import get_background_infrastructure_settings

    config = get_background_infrastructure_settings()
    base_delay = max(1, config.task_default_retry_delay_seconds)
    return min(base_delay * (2**max(0, retry_number)), max(base_delay, config.task_time_limit_seconds))
