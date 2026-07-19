"""Abstract worker lifecycle implementation."""

from __future__ import annotations

import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import Generic, TypeVar

from core.infrastructure.queue.base import QueueBackend, QueueMessage

PayloadT = TypeVar("PayloadT")

logger = logging.getLogger(__name__)


@dataclass(frozen=True, slots=True)
class WorkerResult:
    """Represents the outcome of a worker execution."""

    success: bool
    retry: bool = False
    retry_delay_seconds: int = 0


class Worker(ABC, Generic[PayloadT]):
    """Base class for poll-based background workers."""

    def __init__(self, queue_backend: QueueBackend) -> None:
        self._queue_backend = queue_backend
        self._running = False

    def start(self, max_messages: int = 1, timeout_seconds: int | None = None) -> None:
        """Consume one batch of messages."""

        self._running = True
        logger.info("worker_started", extra={"worker": self.__class__.__name__})
        try:
            for message in self._queue_backend.consume(max_messages=max_messages, timeout_seconds=timeout_seconds):
                self._handle_message(message)
        finally:
            self._running = False
            logger.info("worker_stopped", extra={"worker": self.__class__.__name__})

    def stop(self) -> None:
        """Request a graceful shutdown."""

        self._running = False

    def _handle_message(self, message: QueueMessage) -> None:
        """Deserialize, execute, and settle a queue message."""

        try:
            payload = self.deserialize_payload(message.payload)
            result = self.execute(payload)
            if result.retry:
                logger.warning("worker_retry", extra={"worker": self.__class__.__name__, "message_id": message.message_id})
                self._queue_backend.retry(message.message_id, delay_seconds=result.retry_delay_seconds)
            else:
                self._queue_backend.acknowledge(message.message_id)
                logger.info("worker_acknowledged", extra={"worker": self.__class__.__name__, "message_id": message.message_id})
        except Exception:
            logger.exception("worker_failed", extra={"worker": self.__class__.__name__, "message_id": message.message_id})
            self._queue_backend.reject(message.message_id, requeue=False)

    @abstractmethod
    def deserialize_payload(self, payload: object) -> PayloadT:
        """Convert a raw queue payload into a strongly typed value."""

    @abstractmethod
    def execute(self, payload: PayloadT) -> WorkerResult:
        """Process a typed payload."""

