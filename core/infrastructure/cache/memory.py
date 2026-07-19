"""In-memory cache backend for tests and local development."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from threading import RLock
from typing import Any

from core.infrastructure.cache.base import CacheBackend


@dataclass(slots=True)
class _MemoryItem:
    value: object
    expires_at: datetime | None


class MemoryCacheBackend(CacheBackend):
    """Thread-safe in-memory cache implementation."""

    def __init__(self) -> None:
        """Initialize an empty cache."""

        self._store: dict[str, _MemoryItem] = {}
        self._lock = RLock()

    def get(self, key: str, default: object | None = None) -> object | None:
        """Return a cached value or default."""

        with self._lock:
            item = self._store.get(key)
            if item is None:
                return default
            if item.expires_at is not None and item.expires_at <= datetime.now(timezone.utc):
                self._store.pop(key, None)
                return default
            return item.value

    def set(self, key: str, value: object, timeout: int | None = None) -> None:
        """Store a value with an optional TTL."""

        expires_at = None
        if timeout is not None:
            expires_at = datetime.now(timezone.utc) + timedelta(seconds=timeout)
        with self._lock:
            self._store[key] = _MemoryItem(value=value, expires_at=expires_at)

    def delete(self, key: str) -> bool:
        """Delete a cached value."""

        with self._lock:
            return self._store.pop(key, None) is not None

    def exists(self, key: str) -> bool:
        """Return whether a key exists."""

        return self.get(key, default=None) is not None

    def clear(self) -> None:
        """Remove all cached values."""

        with self._lock:
            self._store.clear()

    def expire(self, key: str, timeout: int | None) -> bool:
        """Update the TTL for an existing key."""

        with self._lock:
            item = self._store.get(key)
            if item is None:
                return False
            expires_at = None
            if timeout is not None:
                expires_at = datetime.now(timezone.utc) + timedelta(seconds=timeout)
            self._store[key] = _MemoryItem(value=item.value, expires_at=expires_at)
            return True

    def increment(self, key: str, delta: int = 1) -> int:
        """Increase a numeric value."""

        with self._lock:
            current = int(self.get(key, 0) or 0)
            new_value = current + delta
            self.set(key, new_value)
            return new_value

    def decrement(self, key: str, delta: int = 1) -> int:
        """Decrease a numeric value."""

        return self.increment(key, -delta)

    def get_many(self, keys: list[str]) -> dict[str, object | None]:
        """Return multiple values at once."""

        return {key: self.get(key) for key in keys}

    def set_many(self, data: dict[str, object], timeout: int | None = None) -> None:
        """Store multiple values at once."""

        for key, value in data.items():
            self.set(key, value, timeout=timeout)

