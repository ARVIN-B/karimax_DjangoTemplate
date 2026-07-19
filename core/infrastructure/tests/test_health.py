"""Tests for infrastructure health checks."""

from __future__ import annotations

from unittest.mock import Mock, patch

from django.test import SimpleTestCase

from core.infrastructure.health import run_infrastructure_health_checks


class HealthTests(SimpleTestCase):
    @patch("core.infrastructure.health.CacheFactory.create")
    @patch("core.infrastructure.health.QueueFactory.create")
    @patch("core.infrastructure.health.DurableBackgroundJobStatusStore")
    def test_run_health_checks(self, store_cls, queue_create, cache_create) -> None:
        cache = Mock()
        cache.get.return_value = "ok"
        cache_create.return_value = cache
        queue_create.return_value = Mock()
        store_cls.return_value = Mock()

        results = run_infrastructure_health_checks()

        self.assertEqual({result.healthy for result in results}, {True})

