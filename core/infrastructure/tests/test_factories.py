"""Factory tests."""

from __future__ import annotations

from django.test import SimpleTestCase, override_settings

from core.infrastructure.factory import CacheFactory, QueueFactory


class FactoryTests(SimpleTestCase):
    """Tests for backend factories."""

    @override_settings(BACKGROUND_CACHE="memory", BACKGROUND_QUEUE="memory")
    def test_creates_memory_backends(self) -> None:
        cache = CacheFactory.create()
        queue = QueueFactory.create()
        self.assertEqual(cache.__class__.__name__, "MemoryCacheBackend")
        self.assertEqual(queue.__class__.__name__, "MemoryQueueBackend")

    @override_settings(BACKGROUND_CACHE="memory", BACKGROUND_QUEUE="celery")
    def test_creates_celery_queue_backend(self) -> None:
        queue = QueueFactory.create()
        self.assertEqual(queue.__class__.__name__, "CeleryQueueBackend")
