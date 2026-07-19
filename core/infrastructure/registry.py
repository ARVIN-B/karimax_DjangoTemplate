"""Backend registries for infrastructure factories."""

from __future__ import annotations

from typing import Callable, TypeVar

from core.infrastructure.exceptions import BackendNotRegisteredError

T = TypeVar("T")


class BackendRegistry[T]:
    """Simple named backend registry."""

    def __init__(self) -> None:
        self._factories: dict[str, Callable[[], T]] = {}

    def register(self, name: str, factory: Callable[[], T]) -> None:
        """Register a backend factory."""

        self._factories[name.lower()] = factory

    def create(self, name: str) -> T:
        """Create a backend by name."""

        try:
            return self._factories[name.lower()]()
        except KeyError as exc:
            raise BackendNotRegisteredError(f"Backend '{name}' is not registered.") from exc

    def names(self) -> tuple[str, ...]:
        """Return registered backend names."""

        return tuple(sorted(self._factories.keys()))

