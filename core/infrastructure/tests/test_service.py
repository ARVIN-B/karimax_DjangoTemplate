"""Tests for background job service helpers."""

from __future__ import annotations

from unittest.mock import Mock, patch

from django.test import SimpleTestCase

from core.infrastructure.exceptions import QueueError
from core.infrastructure.jobs.service import enqueue_transcription_job


class ServiceTests(SimpleTestCase):
    @patch("core.infrastructure.jobs.service.DurableBackgroundJobStatusStore")
    @patch("core.infrastructure.jobs.service.QueueFactory.create")
    def test_enqueue_transcription_job_persists_and_publishes(self, queue_create, store_cls) -> None:
        queue = Mock()
        queue._queue_name = "background"
        queue_create.return_value = queue
        store = store_cls.return_value

        job_id = enqueue_transcription_job(participation_id=5)

        self.assertTrue(job_id)
        store.save.assert_called_once()
        queue.publish.assert_called_once()
        store.update.assert_called_once_with(
            job_id,
            status="WAITING",
            message_id=job_id,
            celery_task_id=job_id,
        )

    @patch("core.infrastructure.jobs.service._mark_participation_failed")
    @patch("core.infrastructure.jobs.service.DurableBackgroundJobStatusStore")
    @patch("core.infrastructure.jobs.service.QueueFactory.create")
    def test_enqueue_transcription_job_marks_failed_on_queue_error(
        self, queue_create, store_cls, mark_failed
    ) -> None:
        queue = Mock()
        queue._queue_name = "background"
        queue.publish.side_effect = QueueError("down")
        queue_create.return_value = queue
        store = store_cls.return_value

        with self.assertRaises(QueueError):
            enqueue_transcription_job(participation_id=5)

        store.update.assert_called()
        mark_failed.assert_called_once_with(5)

    @patch("core.infrastructure.jobs.service.DurableBackgroundJobStatusStore")
    @patch("core.infrastructure.jobs.service.QueueFactory.create")
    def test_enqueue_payload_includes_job_id(self, queue_create, store_cls) -> None:
        queue = Mock()
        queue._queue_name = "background"
        queue_create.return_value = queue

        job_id = enqueue_transcription_job(participation_id=5)
        published = queue.publish.call_args.args[0]
        self.assertEqual(published["payload"]["participation_id"], 5)
        self.assertEqual(published["payload"]["job_id"], job_id)
