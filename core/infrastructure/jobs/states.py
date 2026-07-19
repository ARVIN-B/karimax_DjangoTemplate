"""Background job state definitions."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime


class JobStatus:
    PENDING = "PENDING"
    WAITING = "WAITING"
    RUNNING = "RUNNING"
    SUCCESS = "SUCCESS"
    FAILED = "FAILED"
    RETRYING = "RETRYING"
    CANCELLED = "CANCELLED"


@dataclass(frozen=True, slots=True)
class BackgroundJobRecord:
    job_id: str
    participation_id: int | None
    status: str
    created_at: datetime
    started_at: datetime | None = None
    finished_at: datetime | None = None
    retry_count: int = 0
    last_error: str | None = None
    handler_name: str | None = None
    message_id: str | None = None
    queue: str | None = None
    correlation_id: str | None = None
    worker_hostname: str | None = None
    celery_task_id: str | None = None
