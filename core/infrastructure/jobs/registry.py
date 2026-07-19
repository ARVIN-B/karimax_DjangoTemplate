"""Handler registry for background jobs."""

from __future__ import annotations

from collections.abc import Callable
from dataclasses import dataclass
from typing import Any, Protocol

from core.infrastructure.exceptions import BackendNotRegisteredError


class BackgroundJobHandler(Protocol):
    def handle(self, payload: dict[str, Any]) -> Any: ...


@dataclass(slots=True)
class _HandlerEntry:
    factory: Callable[[], BackgroundJobHandler]


class BackgroundJobHandlerRegistry:
    def __init__(self) -> None:
        self._handlers: dict[str, _HandlerEntry] = {}

    def register(self, name: str, handler: BackgroundJobHandler | Callable[[], BackgroundJobHandler]) -> None:
        if callable(handler) and not hasattr(handler, "handle"):
            factory = handler  # type: ignore[assignment]
        else:
            factory = lambda: handler  # type: ignore[return-value]
        self._handlers[name.lower()] = _HandlerEntry(factory=factory)

    def resolve(self, name: str) -> BackgroundJobHandler:
        try:
            return self._handlers[name.lower()].factory()
        except KeyError as exc:
            raise BackendNotRegisteredError(f"Handler '{name}' is not registered.") from exc

    def names(self) -> tuple[str, ...]:
        return tuple(sorted(self._handlers.keys()))


handler_registry = BackgroundJobHandlerRegistry()

