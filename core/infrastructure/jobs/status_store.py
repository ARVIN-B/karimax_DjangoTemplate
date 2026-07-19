"""Technology-independent background job status store."""

from __future__ import annotations

from dataclasses import asdict
from datetime import datetime
from typing import Any

from core.infrastructure.cache.django_cache import DjangoCacheBackend
from core.infrastructure.cache.memory import MemoryCacheBackend
from core.infrastructure.serializers.json import JSONBackgroundSerializer
from core.infrastructure.settings import get_background_infrastructure_settings


class BackgroundJobStatusStore:
    def save(self, record): ...
    def get(self, job_id: str): ...
    def update(self, job_id: str, **changes: Any): ...


class DatabaseBackgroundJobStatusStore(BackgroundJobStatusStore):
    @staticmethod
    def _model():
        from users.models import BackgroundJob

        return BackgroundJob

    def save(self, record) -> None:
        self._model().objects.update_or_create(
            job_id=record.job_id,
            defaults={
                "participation_id": record.participation_id,
                "handler_name": record.handler_name or "",
                "status": record.status,
                "retry_count": record.retry_count,
                "error_message": record.last_error,
                "started_at": record.started_at,
                "finished_at": record.finished_at,
                "message_id": record.message_id,
                "queue": record.queue,
                "correlation_id": getattr(record, "correlation_id", None),
                "worker_hostname": record.worker_hostname,
                "celery_task_id": record.celery_task_id,
            },
        )

    def get(self, job_id: str):
        job = self._model().objects.filter(job_id=job_id).first()
        if job is None:
            return None
        from core.infrastructure.jobs.states import BackgroundJobRecord

        return BackgroundJobRecord(
            job_id=job.job_id,
            participation_id=job.participation_id,
            status=job.status,
            created_at=job.created_at,
            started_at=job.started_at,
            finished_at=job.finished_at,
            retry_count=job.retry_count,
            last_error=job.error_message,
            handler_name=job.handler_name,
            message_id=job.message_id,
            queue=job.queue,
            correlation_id=job.correlation_id,
            worker_hostname=job.worker_hostname,
            celery_task_id=job.celery_task_id,
        )

    def update(self, job_id: str, **changes: Any):
        existing = self.get(job_id)
        if existing is None:
            return None
        data = asdict(existing)
        data.update(changes)
        record = type(existing)(**data)
        self.save(record)
        return record


class CacheBackgroundJobStatusStore(BackgroundJobStatusStore):
    def __init__(self, cache_backend: DjangoCacheBackend | MemoryCacheBackend | None = None) -> None:
        self._cache = cache_backend or DjangoCacheBackend()
        self._serializer = JSONBackgroundSerializer()
        self._prefix = "background_job:"
        self._ttl = get_background_infrastructure_settings().default_ttl_seconds

    def _key(self, job_id: str) -> str:
        return f"{self._prefix}{job_id}"

    def save(self, record) -> None:
        self._cache.set(self._key(record.job_id), self._serializer.dumps(asdict(record)), timeout=self._ttl)

    def get(self, job_id: str):
        raw = self._cache.get(self._key(job_id))
        if not raw:
            return None
        data = self._serializer.loads(raw) if isinstance(raw, str) else raw
        from core.infrastructure.jobs.states import BackgroundJobRecord

        return BackgroundJobRecord(
            job_id=data["job_id"],
            participation_id=data.get("participation_id"),
            status=data["status"],
            created_at=datetime.fromisoformat(data["created_at"]),
            started_at=datetime.fromisoformat(data["started_at"]) if data.get("started_at") else None,
            finished_at=datetime.fromisoformat(data["finished_at"]) if data.get("finished_at") else None,
            retry_count=int(data.get("retry_count", 0)),
            last_error=data.get("last_error"),
            handler_name=data.get("handler_name"),
            message_id=data.get("message_id"),
            queue=data.get("queue"),
            worker_hostname=data.get("worker_hostname"),
            celery_task_id=data.get("celery_task_id"),
        )

    def update(self, job_id: str, **changes: Any):
        existing = self.get(job_id)
        if existing is None:
            return None
        data = asdict(existing)
        data.update(changes)
        from core.infrastructure.jobs.states import BackgroundJobRecord

        record = BackgroundJobRecord(**data)
        self.save(record)
        return record


class DurableBackgroundJobStatusStore(BackgroundJobStatusStore):
    def __init__(self) -> None:
        self._database = DatabaseBackgroundJobStatusStore()
        self._cache = CacheBackgroundJobStatusStore()

    def save(self, record) -> None:
        self._database.save(record)
        self._cache.save(record)

    def get(self, job_id: str):
        record = self._database.get(job_id)
        if record is not None:
            return record
        return self._cache.get(job_id)

    def update(self, job_id: str, **changes: Any):
        record = self._database.update(job_id, **changes)
        if record is None:
            record = self._cache.update(job_id, **changes)
        if record is not None:
            self._cache.save(record)
        return record
