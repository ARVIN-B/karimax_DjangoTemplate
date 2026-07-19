"""Factories for cache and queue backends."""

from __future__ import annotations

from core.infrastructure.cache.django_cache import DjangoCacheBackend
from core.infrastructure.cache.memory import MemoryCacheBackend
from core.infrastructure.queue.celery import CeleryQueueBackend
from core.infrastructure.queue.memory import MemoryQueueBackend
from core.infrastructure.registry import BackendRegistry
from core.infrastructure.settings import get_background_infrastructure_settings
from pmss.celery import app as celery_app


class CacheFactory:
    """Factory for cache backend instances."""

    _registry: BackendRegistry[object] = BackendRegistry()

    @classmethod
    def register_defaults(cls) -> None:
        """Register built-in cache backends."""

        cls._registry.register("memory", MemoryCacheBackend)
        cls._registry.register("redis", lambda: DjangoCacheBackend(alias=get_background_infrastructure_settings().cache_alias))

    @classmethod
    def create(cls):
        """Create the configured cache backend."""

        if not cls._registry.names():
            cls.register_defaults()
        settings_obj = get_background_infrastructure_settings()
        return cls._registry.create(settings_obj.cache_backend)


class QueueFactory:
    """Factory for queue backend instances."""

    _registry: BackendRegistry[object] = BackendRegistry()

    @classmethod
    def register_defaults(cls) -> None:
        """Register built-in queue backends."""

        cls._registry.register("memory", MemoryQueueBackend)
        cls._registry.register(
            "celery",
            lambda: CeleryQueueBackend(
                app=celery_app,
                task_name=get_background_infrastructure_settings().background_queue_task_name,
                queue_name=get_background_infrastructure_settings().queue_name,
                default_retry_delay_seconds=get_background_infrastructure_settings().task_default_retry_delay_seconds,
                max_retries=get_background_infrastructure_settings().task_max_retries,
            ),
        )

    @classmethod
    def create(cls):
        """Create the configured queue backend."""

        if not cls._registry.names():
            cls.register_defaults()
        settings_obj = get_background_infrastructure_settings()
        return cls._registry.create(settings_obj.queue_backend)
