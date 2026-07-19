"""Registry tests."""

from __future__ import annotations

from django.test import SimpleTestCase

from core.infrastructure.exceptions import BackendNotRegisteredError
from core.infrastructure.registry import BackendRegistry


class RegistryTests(SimpleTestCase):
    """Tests for backend registries."""

    def test_register_and_create(self) -> None:
        registry = BackendRegistry[int]()
        registry.register("one", lambda: 1)
        self.assertEqual(registry.create("one"), 1)

    def test_missing_backend_raises(self) -> None:
        registry = BackendRegistry[int]()
        with self.assertRaises(BackendNotRegisteredError):
            registry.create("missing")

