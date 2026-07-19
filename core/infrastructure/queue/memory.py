"""In-memory queue backend for tests and local development."""

from __future__ import annotations

from collections import deque
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from threading import Condition, RLock
from uuid import uuid4

from core.infrastructure.queue.base import QueueMessage


@dataclass(slots=True)
class _QueuedItem:
    message: QueueMessage


class MemoryQueueBackend:
    """Thread-safe in-memory queue implementation."""

    def __init__(self) -> None:
        self._queue: deque[_QueuedItem] = deque()
        self._inflight: dict[str, _QueuedItem] = {}
        self._lock = RLock()
        self._condition = Condition(self._lock)

    def publish(self, payload: object, delay_seconds: int = 0) -> str:
        message_id = str(uuid4())
        now = datetime.now(timezone.utc)
        available_at = now + timedelta(seconds=delay_seconds) if delay_seconds > 0 else None
        message = QueueMessage(
            message_id=message_id,
            payload=payload,
            created_at=now,
            available_at=available_at,
        )
        with self._condition:
            self._queue.append(_QueuedItem(message=message))
            self._condition.notify_all()
        return message_id

    def consume(self, max_messages: int = 1, timeout_seconds: int | None = None) -> list[QueueMessage]:
        deadline = None if timeout_seconds is None else datetime.now(timezone.utc) + timedelta(seconds=timeout_seconds)
        messages: list[QueueMessage] = []
        with self._condition:
            while not self._queue and timeout_seconds:
                remaining = (deadline - datetime.now(timezone.utc)).total_seconds() if deadline else 0
                if remaining <= 0:
                    break
                self._condition.wait(timeout=remaining)
            now = datetime.now(timezone.utc)
            for _ in range(min(max_messages, len(self._queue))):
                item = self._queue.popleft()
                if item.message.available_at and item.message.available_at > now:
                    self._queue.append(item)
                    continue
                self._inflight[item.message.message_id] = item
                messages.append(item.message)
        return messages

    def acknowledge(self, message_id: str) -> None:
        with self._condition:
            self._inflight.pop(message_id, None)

    def reject(self, message_id: str, requeue: bool = False) -> None:
        with self._condition:
            item = self._inflight.pop(message_id, None)
            if item is not None and requeue:
                self._queue.append(item)
                self._condition.notify_all()

    def retry(self, message_id: str, delay_seconds: int = 0) -> None:
        with self._condition:
            item = self._inflight.pop(message_id, None)
            if item is None:
                return
            message = item.message
            delayed = QueueMessage(
                message_id=message.message_id,
                payload=message.payload,
                created_at=message.created_at,
                available_at=datetime.now(timezone.utc) + timedelta(seconds=delay_seconds) if delay_seconds else None,
                attempts=message.attempts + 1,
            )
            self._queue.append(_QueuedItem(message=delayed))
            self._condition.notify_all()

    def delay(self, payload: object, delay_seconds: int) -> str:
        return self.publish(payload, delay_seconds=delay_seconds)

    def schedule(self, payload: object, run_at: datetime) -> str:
        now = datetime.now(timezone.utc)
        delay_seconds = max(0, int((run_at - now).total_seconds()))
        return self.publish(payload, delay_seconds=delay_seconds)

