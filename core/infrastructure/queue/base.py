"""Queue backend contracts and payload types."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from typing import Any, Protocol


@dataclass(frozen=True, slots=True)
class QueueMessage:
    """A normalized queue message envelope."""

    message_id: str
    payload: object
    created_at: datetime
    available_at: datetime | None = None
    attempts: int = 0


class QueueBackend(Protocol):
    """
    Technology-agnostic queue contract.

    Implementations may use Redis, Kafka, RabbitMQ, SQS,
    Google Pub/Sub or any future backend without changing
    the application layer.
    """

    def publish(
        self,
        payload: object,
        *,
        delay_seconds: int = 0,
    ) -> str: ...

    def consume(
        self,
        *,
        max_messages: int = 1,
        timeout_seconds: int | None = None,
    ) -> list[QueueMessage]: ...

    def acknowledge(
        self,
        message_id: str,
    ) -> None: ...

    def reject(
        self,
        message_id: str,
        *,
        requeue: bool = False,
    ) -> None: ...

    def retry(
        self,
        message_id: str,
        *,
        delay_seconds: int = 0,
    ) -> None: ...

    def delay(
        self,
        payload: object,
        delay_seconds: int,
    ) -> str: ...

    def schedule(
        self,
        payload: object,
        run_at: datetime,
    ) -> str: ...
