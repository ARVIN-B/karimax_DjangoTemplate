"""Tests for background job status stores."""

from __future__ import annotations

from datetime import datetime, timezone
from unittest.mock import patch

from django.test import SimpleTestCase

from core.infrastructure.jobs.states import BackgroundJobRecord, JobStatus
from core.infrastructure.jobs.status_store import DurableBackgroundJobStatusStore


class StatusStoreTests(SimpleTestCase):
    @patch("core.infrastructure.jobs.status_store.DatabaseBackgroundJobStatusStore")
    @patch("core.infrastructure.jobs.status_store.CacheBackgroundJobStatusStore")
    def test_durable_store_saves_to_both_backends(self, cache_cls, db_cls) -> None:
        db = db_cls.return_value
        cache = cache_cls.return_value
        store = DurableBackgroundJobStatusStore()
        record = BackgroundJobRecord(
            job_id="job-1",
            participation_id=7,
            status=JobStatus.WAITING,
            created_at=datetime.now(timezone.utc),
            handler_name="transcription",
        )

        store.save(record)

        db.save.assert_called_once()
        cache.save.assert_called_once()

