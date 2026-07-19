"""Tests for the Celery queue backend."""

from __future__ import annotations

from datetime import datetime, timedelta, timezone
from unittest.mock import Mock

from django.test import SimpleTestCase

from core.infrastructure.exceptions import QueueError
from core.infrastructure.queue.celery import CeleryQueueBackend


class CeleryQueueBackendTests(SimpleTestCase):
    def setUp(self) -> None:
        self.app = Mock()
        self.backend = CeleryQueueBackend(
            app=self.app,
            task_name="core.infrastructure.tasks.cleanup_expired_background_jobs",
            queue_name="background",
        )

    def test_publish_sends_json_payload_to_celery(self) -> None:
        message_id = self.backend.publish({"participation_id": 145})

        self.assertTrue(message_id)
        self.app.send_task.assert_called_once()
        args, kwargs = self.app.send_task.call_args
        self.assertEqual(args[0], "core.infrastructure.tasks.cleanup_expired_background_jobs")
        self.assertEqual(kwargs["queue"], "background")
        self.assertEqual(kwargs["serializer"], "json")
        self.assertEqual(kwargs["task_id"], message_id)
        self.assertEqual(kwargs["args"][0].find('"participation_id": 145') > -1, True)

    def test_delay_uses_countdown(self) -> None:
        self.backend.publish({"x": 1}, delay_seconds=30)
        _, kwargs = self.app.send_task.call_args
        self.assertEqual(kwargs["countdown"], 30)

    def test_schedule_converts_datetime_to_delay(self) -> None:
        run_at = datetime.now(timezone.utc) + timedelta(seconds=15)
        self.backend.schedule({"x": 1}, run_at)
        _, kwargs = self.app.send_task.call_args
        self.assertGreaterEqual(kwargs["countdown"], 14)

    def test_publish_wraps_send_task_errors(self) -> None:
        self.app.send_task.side_effect = RuntimeError("broker down")

        with self.assertRaises(QueueError):
            self.backend.publish({"x": 1})
