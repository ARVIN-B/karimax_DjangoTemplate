"""Custom exceptions for infrastructure backends."""

from __future__ import annotations


class BackgroundInfrastructureError(Exception):
    """Base exception for infrastructure failures."""


class BackgroundJobPermanentError(BackgroundInfrastructureError):
    """Raised when a background job cannot be retried safely."""


class BackgroundJobRetryableError(BackgroundInfrastructureError):
    """Raised when a background job should be retried."""


class SerializationError(BackgroundInfrastructureError):
    """Raised when serialization or deserialization fails."""


class CacheError(BackgroundInfrastructureError):
    """Raised when a cache operation fails."""


class CacheConnectionError(CacheError):
    """Raised when a cache backend cannot be reached."""


class QueueError(BackgroundInfrastructureError):
    """Raised when a queue operation fails."""


class QueueTimeoutError(QueueError):
    """Raised when a queue operation times out."""


class BackendNotRegisteredError(BackgroundInfrastructureError):
    """Raised when a requested backend name is unknown."""
