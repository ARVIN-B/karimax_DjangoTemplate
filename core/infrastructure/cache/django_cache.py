"""Django cache adapter hidden behind the cache contract."""

from __future__ import annotations

from django.core.cache import caches

from core.infrastructure.cache.base import CacheBackend


class DjangoCacheBackend(CacheBackend):
    """Adapter around Django's cache interface."""

    def __init__(self, alias: str = "default") -> None:
        """Initialize the adapter for a configured Django cache alias."""

        self._cache = caches[alias]

    def get(self, key: str, default: object | None = None) -> object | None:
        return self._cache.get(key, default)

    def set(self, key: str, value: object, timeout: int | None = None) -> None:
        self._cache.set(key, value, timeout=timeout)

    def delete(self, key: str) -> bool:
        return bool(self._cache.delete(key))

    def exists(self, key: str) -> bool:
        return bool(self._cache.get(key, None) is not None)

    def clear(self) -> None:
        self._cache.clear()

    def expire(self, key: str, timeout: int | None) -> bool:
        value = self._cache.get(key, None)
        if value is None:
            return False
        self._cache.set(key, value, timeout=timeout)
        return True

    def increment(self, key: str, delta: int = 1) -> int:
        return self._cache.incr(key, delta)

    def decrement(self, key: str, delta: int = 1) -> int:
        return self._cache.decr(key, delta)

    def get_many(self, keys: list[str]) -> dict[str, object | None]:
        return self._cache.get_many(keys)

    def set_many(self, data: dict[str, object], timeout: int | None = None) -> None:
        self._cache.set_many(data, timeout=timeout)

