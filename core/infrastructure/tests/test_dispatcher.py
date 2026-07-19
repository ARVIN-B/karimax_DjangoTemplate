"""Tests for the background job dispatcher."""

from __future__ import annotations

from unittest.mock import Mock, patch

from django.test import SimpleTestCase

from core.infrastructure.exceptions import BackendNotRegisteredError, SerializationError
from core.infrastructure.jobs.dispatcher import BackgroundJobDispatcher


class DispatcherTests(SimpleTestCase):
    def setUp(self) -> None:
        self.status_store = Mock()
        self.dispatcher = BackgroundJobDispatcher(status_store=self.status_store)

    def test_dispatch_unknown_handler_marks_failed(self) -> None:
        with patch("core.infrastructure.jobs.dispatcher.ensure_default_handlers"), patch(
            "core.infrastructure.jobs.dispatcher.handler_registry.resolve",
            side_effect=BackendNotRegisteredError("missing"),
        ), patch("core.infrastructure.jobs.dispatcher.JSONBackgroundSerializer.loads", return_value={
            "job_id": "job-1",
            "handler_name": "unknown",
            "payload": {},
        }):
            with self.assertRaises(Exception):
                self.dispatcher.dispatch("{}")

    def test_invalid_payload_raises_serialization_error(self) -> None:
        with patch("core.infrastructure.jobs.dispatcher.JSONBackgroundSerializer.loads", return_value={"handler_name": "x"}):
            with self.assertRaises(SerializationError):
                self.dispatcher.dispatch("{}")
