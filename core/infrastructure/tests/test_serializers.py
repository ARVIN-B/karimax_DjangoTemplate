"""Serializer tests."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from decimal import Decimal
from uuid import UUID

from django.test import SimpleTestCase

from core.infrastructure.serializers.json import JSONBackgroundSerializer


@dataclass(frozen=True)
class SamplePayload:
    participation_id: int


class JSONBackgroundSerializerTests(SimpleTestCase):
    """Tests for the JSON serializer."""

    def setUp(self) -> None:
        self.serializer = JSONBackgroundSerializer()

    def test_dumps_dataclass(self) -> None:
        payload = SamplePayload(participation_id=15)
        result = self.serializer.dumps(payload)
        self.assertIn('"participation_id": 15', result)

    def test_dumps_datetime_decimal_and_uuid(self) -> None:
        payload = {
            "when": datetime(2024, 1, 1, tzinfo=timezone.utc),
            "price": Decimal("12.50"),
            "id": UUID("12345678-1234-5678-1234-567812345678"),
        }
        result = self.serializer.dumps(payload)
        self.assertIn("2024-01-01T00:00:00+00:00", result)
        self.assertIn('"12.50"', result)
        self.assertIn("12345678-1234-5678-1234-567812345678", result)

