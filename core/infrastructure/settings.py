"""Typed settings for background infrastructure."""

from __future__ import annotations

from dataclasses import dataclass
from django.conf import settings


@dataclass(frozen=True, slots=True)
class BackgroundInfrastructureSettings:
    """Typed view over Django settings for background infrastructure."""

    cache_backend: str
    queue_backend: str
    cache_alias: str
    queue_namespace: str
    default_ttl_seconds: int
    poll_interval_seconds: float
    broker_url: str
    result_backend: str
    queue_name: str
    task_default_retry_delay_seconds: int
    task_max_retries: int
    task_soft_time_limit_seconds: int
    task_time_limit_seconds: int
    worker_prefetch_multiplier: int
    worker_concurrency: int
    worker_log_level: str
    visibility_timeout_seconds: int
    task_serializer: str
    result_serializer: str
    accept_content: tuple[str, ...]
    background_queue_task_name: str
    job_retention_days: int
    cache_url: str


def get_background_infrastructure_settings() -> BackgroundInfrastructureSettings:
    """Return the typed settings object for background infrastructure."""

    return BackgroundInfrastructureSettings(
        cache_backend=getattr(settings, "BACKGROUND_CACHE", "redis"),
        queue_backend=getattr(settings, "BACKGROUND_QUEUE", "celery"),
        cache_alias=getattr(settings, "BACKGROUND_CACHE_ALIAS", "default"),
        queue_namespace=getattr(settings, "BACKGROUND_QUEUE_NAMESPACE", "background"),
        default_ttl_seconds=int(getattr(settings, "BACKGROUND_CACHE_TTL_SECONDS", 300)),
        poll_interval_seconds=float(
            getattr(settings, "BACKGROUND_QUEUE_POLL_INTERVAL_SECONDS", 0.2)
        ),
        broker_url=str(getattr(settings, "CELERY_BROKER_URL", "redis://127.0.0.1:6379/0")),
        result_backend=str(getattr(settings, "CELERY_RESULT_BACKEND", "redis://127.0.0.1:6379/1")),
        queue_name=str(getattr(settings, "CELERY_TASK_DEFAULT_QUEUE", "background")),
        task_default_retry_delay_seconds=int(getattr(settings, "CELERY_TASK_DEFAULT_RETRY_DELAY_SECONDS", 5)),
        task_max_retries=int(getattr(settings, "CELERY_TASK_MAX_RETRIES", 5)),
        task_soft_time_limit_seconds=int(getattr(settings, "CELERY_TASK_SOFT_TIME_LIMIT_SECONDS", 300)),
        task_time_limit_seconds=int(getattr(settings, "CELERY_TASK_TIME_LIMIT_SECONDS", 330)),
        worker_prefetch_multiplier=int(getattr(settings, "CELERY_WORKER_PREFETCH_MULTIPLIER", 1)),
        worker_concurrency=int(getattr(settings, "CELERY_WORKER_CONCURRENCY", 1)),
        worker_log_level=str(getattr(settings, "CELERY_WORKER_LOG_LEVEL", "INFO")),
        visibility_timeout_seconds=int(getattr(settings, "CELERY_BROKER_TRANSPORT_OPTIONS_VISIBILITY_TIMEOUT", 3600)),
        task_serializer=str(getattr(settings, "CELERY_TASK_SERIALIZER", "json")),
        result_serializer=str(getattr(settings, "CELERY_RESULT_SERIALIZER", "json")),
        accept_content=tuple(getattr(settings, "CELERY_ACCEPT_CONTENT", ["json"])),
        background_queue_task_name=str(
            getattr(settings, "BACKGROUND_QUEUE_TASK_NAME", "core.infrastructure.tasks.dispatch_background_job")
        ),
        job_retention_days=int(getattr(settings, "BACKGROUND_JOB_RETENTION_DAYS", 30)),
        cache_url=str(getattr(settings, "REDIS_CACHE_URL", "redis://127.0.0.1:6379/2")),
    )
