"""Serializer contract for background infrastructure."""

from __future__ import annotations

from typing import Protocol, TypeVar

T = TypeVar("T")


class Serializer(Protocol):
    """Contract for safe serialization of background payloads."""

    def dumps(self, value: object) -> str:
        """Serialize a Python object into a string."""

    def loads(self, payload: str) -> object:
        """Deserialize a string into a Python object."""

