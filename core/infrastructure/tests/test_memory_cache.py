"""Memory cache backend tests."""

from __future__ import annotations

from django.test import SimpleTestCase

from core.infrastructure.cache.memory import MemoryCacheBackend


class MemoryCacheBackendTests(SimpleTestCase):
    """Tests for the in-memory cache backend."""

    def setUp(self) -> None:
        self.cache = MemoryCacheBackend()

    def test_set_get_and_delete(self) -> None:
        self.cache.set("answer", 42)
        self.assertEqual(self.cache.get("answer"), 42)
        self.assertTrue(self.cache.exists("answer"))
        self.assertTrue(self.cache.delete("answer"))
        self.assertIsNone(self.cache.get("answer"))

    def test_increment_and_decrement(self) -> None:
        self.cache.set("counter", 1)
        self.assertEqual(self.cache.increment("counter"), 2)
        self.assertEqual(self.cache.decrement("counter"), 1)

