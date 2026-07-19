"""Worker base tests."""

from __future__ import annotations

from dataclasses import dataclass

from django.test import SimpleTestCase

from core.infrastructure.queue.memory import MemoryQueueBackend
from core.infrastructure.workers.base import Worker, WorkerResult


@dataclass(frozen=True)
class DemoPayload:
    participation_id: int


class DemoWorker(Worker[DemoPayload]):
    def deserialize_payload(self, payload: object) -> DemoPayload:
        assert isinstance(payload, dict)
        return DemoPayload(participation_id=int(payload["participation_id"]))

    def execute(self, payload: DemoPayload) -> WorkerResult:
        self.processed = payload.participation_id
        return WorkerResult(success=True)


class WorkerTests(SimpleTestCase):
    """Tests for the abstract worker implementation."""

    def test_worker_processes_message(self) -> None:
        queue = MemoryQueueBackend()
        queue.publish({"participation_id": 15})
        worker = DemoWorker(queue)
        worker.start()
        self.assertEqual(worker.processed, 15)

