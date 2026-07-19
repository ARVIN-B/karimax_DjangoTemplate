"""Lazy bootstrap for default background job handlers."""

from __future__ import annotations

from functools import lru_cache


@lru_cache(maxsize=1)
def ensure_default_handlers() -> None:
    from core.infrastructure.jobs.handlers.transcription import TranscriptionHandler
    from core.infrastructure.jobs.registry import handler_registry

    if "transcription" not in handler_registry.names():
        handler_registry.register("transcription", TranscriptionHandler())

