"""Reusable infrastructure health checks."""

from __future__ import annotations

from dataclasses import dataclass

from core.infrastructure.factory import CacheFactory, QueueFactory
from core.infrastructure.jobs.status_store import DurableBackgroundJobStatusStore


@dataclass(frozen=True, slots=True)
class HealthCheckResult:
    name: str
    healthy: bool
    detail: str = ""


def check_cache_backend() -> HealthCheckResult:
    try:
        cache = CacheFactory.create()
        cache.set("__healthcheck__", "ok", timeout=5)
        ok = cache.get("__healthcheck__") == "ok"
        return HealthCheckResult("cache_backend", ok, "ok" if ok else "unexpected cache value")
    except Exception as exc:
        return HealthCheckResult("cache_backend", False, str(exc))


def check_queue_backend() -> HealthCheckResult:
    try:
        queue = QueueFactory.create()
        app = getattr(queue, "_app", None)
        if app is not None:
            connection = app.connection_for_write()
            connection.ensure_connection(max_retries=1)
            connection.close()
        return HealthCheckResult("queue_backend", True, "connected")
    except Exception as exc:
        return HealthCheckResult("queue_backend", False, str(exc))


def check_status_store() -> HealthCheckResult:
    try:
        store = DurableBackgroundJobStatusStore()
        ok = store is not None
        return HealthCheckResult("status_store", ok, "created")
    except Exception as exc:
        return HealthCheckResult("status_store", False, str(exc))


def run_infrastructure_health_checks() -> list[HealthCheckResult]:
    return [check_cache_backend(), check_queue_backend(), check_status_store()]
