"""Safe JSON serializer for dataclasses and common Python types."""

from __future__ import annotations

from dataclasses import asdict, is_dataclass
from datetime import date, datetime
from decimal import Decimal
import json
from typing import Any
from uuid import UUID

from core.infrastructure.exceptions import SerializationError
from core.infrastructure.serializers.base import Serializer


class JSONBackgroundSerializer(Serializer):
    """Serialize background payloads using JSON only."""

    def dumps(self, value: object) -> str:
        """Serialize a supported Python object into JSON."""

        try:
            return json.dumps(value, cls=_BackgroundJSONEncoder, ensure_ascii=False)
        except (TypeError, ValueError) as exc:
            raise SerializationError(str(exc)) from exc

    def loads(self, payload: str) -> object:
        """Deserialize a JSON payload."""

        try:
            return json.loads(payload)
        except json.JSONDecodeError as exc:
            raise SerializationError(str(exc)) from exc


class _BackgroundJSONEncoder(json.JSONEncoder):
    """JSON encoder with support for dataclasses and common primitives."""

    def default(self, o: Any) -> Any:
        if is_dataclass(o):
            return asdict(o)
        if isinstance(o, (datetime, date)):
            return o.isoformat()
        if isinstance(o, Decimal):
            return str(o)
        if isinstance(o, UUID):
            return str(o)
        return super().default(o)

