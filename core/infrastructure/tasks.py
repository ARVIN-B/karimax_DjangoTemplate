"""Shared infrastructure tasks."""

from __future__ import annotations

import json
import logging
import time
from datetime import timedelta

from celery import shared_task
from django.conf import settings
from django.utils import timezone

logger = logging.getLogger(__name__)

from core.infrastructure.exceptions import BackgroundJobRetryableError
from core.infrastructure.jobs.dispatcher import BackgroundJobDispatcher
from core.infrastructure.jobs.service import get_retry_delay_seconds
from core.infrastructure.jobs.status_store import DurableBackgroundJobStatusStore
from core.infrastructure.settings import get_background_infrastructure_settings


@shared_task(bind=True, name="core.infrastructure.tasks.dispatch_background_job")
def dispatch_background_job(self, raw_message: str) -> object:
    started_monotonic = time.monotonic()
    queue_name = getattr(self.request, "delivery_info", {}).get("routing_key")
    print(
        f"[STT] celery_task_received task_id={self.request.id} queue={queue_name}",
        flush=True,
    )
    logger.info(
        "task_received",
        extra={
            "message_id": self.request.id,
            "queue": queue_name,
            "correlation_id": getattr(self.request, "correlation_id", None),
        },
    )
    logger.info(
        "task_started",
        extra={
            "message_id": self.request.id,
            "queue": queue_name,
            "correlation_id": getattr(self.request, "correlation_id", None),
        },
    )
    try:
        result = BackgroundJobDispatcher().dispatch(raw_message)
        logger.info(
            "task_finished",
            extra={
                "message_id": self.request.id,
                "queue": queue_name,
                "correlation_id": getattr(self.request, "correlation_id", None),
                "duration_ms": round((time.monotonic() - started_monotonic) * 1000, 2),
            },
        )
        return result
    except BackgroundJobRetryableError as exc:
        infrastructure_settings = get_background_infrastructure_settings()
        if self.request.retries >= infrastructure_settings.task_max_retries:
            try:
                job_id = json.loads(raw_message).get("job_id")
                if job_id:
                    DurableBackgroundJobStatusStore().update(
                        job_id,
                        status="FAILED",
                        last_error=f"Retry limit exceeded: {exc}",
                    )
            except (TypeError, ValueError, AttributeError):
                logger.exception("retry_exhaustion_status_update_failed", extra={"task_id": self.request.id})
            raise
        logger.warning(
            "retry_executed",
            extra={
                "message_id": self.request.id,
                "queue": queue_name,
                "correlation_id": getattr(self.request, "correlation_id", None),
            },
        )
        raise self.retry(
            exc=exc,
            countdown=get_retry_delay_seconds(self.request.retries),
            max_retries=infrastructure_settings.task_max_retries,
        )
    except Exception:
        logger.exception(
            "task_failed",
            extra={
                "message_id": self.request.id,
                "queue": queue_name,
                "correlation_id": getattr(self.request, "correlation_id", None),
            },
        )
        raise


@shared_task(bind=True, name="core.infrastructure.tasks.cleanup_expired_background_jobs")
def cleanup_expired_background_jobs(self) -> str:
    """Delete completed background-job metadata past the retention window."""

    from users.models import BackgroundJob
    retention_days = max(1, int(settings.BACKGROUND_JOB_RETENTION_DAYS))
    cutoff = timezone.now() - timedelta(days=retention_days)
    deleted, _ = BackgroundJob.objects.filter(
        finished_at__lt=cutoff,
        status__in=("SUCCESS", "FAILED", "CANCELLED"),
    ).delete()
    logger.info(
        "background_cleanup_completed",
        extra={"task_id": self.request.id, "deleted_count": deleted, "retention_days": retention_days},
    )
    return str(deleted)
