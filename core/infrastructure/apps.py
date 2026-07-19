"""Django app configuration for background infrastructure."""

from __future__ import annotations

from django.apps import AppConfig


class InfrastructureConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "core.infrastructure"
    verbose_name = "Infrastructure"

