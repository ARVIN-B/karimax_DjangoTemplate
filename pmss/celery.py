"""Celery application configuration for PMSS."""

from __future__ import annotations

import os

from celery import Celery
from celery.schedules import crontab
from django.conf import settings

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "pmss.settings")

app = Celery("pmss")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks(["core.infrastructure"])

app.conf.update(
    broker_url=getattr(settings, "CELERY_BROKER_URL", "redis://127.0.0.1:6379/0"),
    result_backend=getattr(settings, "CELERY_RESULT_BACKEND", "redis://127.0.0.1:6379/1"),
    task_serializer=getattr(settings, "CELERY_TASK_SERIALIZER", "json"),
    result_serializer=getattr(settings, "CELERY_RESULT_SERIALIZER", "json"),
    accept_content=getattr(settings, "CELERY_ACCEPT_CONTENT", ["json"]),
    task_acks_late=True,
    task_reject_on_worker_lost=True,
    worker_prefetch_multiplier=getattr(settings, "CELERY_WORKER_PREFETCH_MULTIPLIER", 1),
    task_soft_time_limit=getattr(settings, "CELERY_TASK_SOFT_TIME_LIMIT_SECONDS", 300),
    task_time_limit=getattr(settings, "CELERY_TASK_TIME_LIMIT_SECONDS", 330),
    worker_concurrency=getattr(settings, "CELERY_WORKER_CONCURRENCY", 1),
    worker_hijack_root_logger=False,
    broker_connection_retry_on_startup=True,
    broker_heartbeat=30,
    broker_transport_options={
        "visibility_timeout": getattr(settings, "CELERY_BROKER_TRANSPORT_OPTIONS_VISIBILITY_TIMEOUT", 3600),
        "max_retries": 10,
        "interval_start": 0,
        "interval_step": 1,
        "interval_max": 10,
    },
    result_backend_transport_options={
        "retry_policy": {"max_retries": 10, "interval_start": 0, "interval_step": 1, "interval_max": 10},
    },
    beat_schedule={
        "background-cleanup": {
            "task": "core.infrastructure.tasks.cleanup_expired_background_jobs",
            "schedule": crontab(minute="*/5"),
        }
    },
)
