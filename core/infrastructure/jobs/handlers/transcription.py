"""Speech-to-text background handler."""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from django.db import transaction

from core.infrastructure.exceptions import BackgroundJobPermanentError, BackgroundJobRetryableError

logger = logging.getLogger(__name__)


@dataclass(slots=True)
class TranscriptionHandler:
    def handle(self, payload: dict[str, Any]) -> dict[str, Any]:
        from STT_full_file.speech_recognition_full_file import STT_full_file
        from users.exceptions import STTConnectionError, STTError
        from users.models import Participation

        participation_id = int(payload["participation_id"])
        job_id = str(payload.get("job_id") or "")
        logger.info(
            "handler_started",
            extra={
                "handler_name": "transcription",
                "participation_id": participation_id,
                "job_id": job_id,
            },
        )
        temp_wav_path: str | None = None
        text = ""
        try:
            print(
                f"[STT] handler_started participation_id={participation_id} job_id={job_id}",
                flush=True,
            )
            with transaction.atomic():
                participation = Participation.objects.select_for_update().get(id=participation_id)
                if not participation.attachment:
                    raise BackgroundJobPermanentError("پیوست صوتی برای تبدیل وجود ندارد.")
                file_path = participation.attachment.path
                if not os.path.exists(file_path):
                    raise BackgroundJobPermanentError(f"فایل یافت نشد: {file_path}")

            temp_wav_path = str(Path(file_path).with_suffix("")) + "_temp.wav"
            logger.info(
                "speech_started",
                extra={
                    "handler_name": "transcription",
                    "participation_id": participation_id,
                    "job_id": job_id,
                    "file_path": file_path,
                },
            )
            print(
                f"[STT] speech_started participation_id={participation_id} file={file_path}",
                flush=True,
            )
            try:
                text = STT_full_file(file_path, temp_wav_path, participation_id)
            except (STTConnectionError, ConnectionError, TimeoutError, OSError) as exc:
                raise BackgroundJobRetryableError("Speech-to-Text service is temporarily unavailable.") from exc
            except STTError as exc:
                raise BackgroundJobPermanentError(str(exc)) from exc

            logger.info(
                "speech_finished",
                extra={
                    "handler_name": "transcription",
                    "participation_id": participation_id,
                    "job_id": job_id,
                    "text_length": len(text or ""),
                },
            )
            print(
                f"[STT] speech_finished participation_id={participation_id} text_length={len(text or '')}",
                flush=True,
            )

            with transaction.atomic():
                participation = Participation.objects.select_for_update().get(id=participation_id)
                participation.text_content = text
                participation.orginal_content = text
                participation.status = "user_review"
                participation.save(update_fields=["text_content", "orginal_content", "status"])
            logger.info(
                "database_updated",
                extra={
                    "handler_name": "transcription",
                    "participation_id": participation_id,
                    "job_id": job_id,
                    "status": "user_review",
                    "text_length": len(text or ""),
                },
            )
            print(
                f"[STT] database_updated participation_id={participation_id} status=user_review",
                flush=True,
            )

            logger.info(
                "handler_finished",
                extra={
                    "handler_name": "transcription",
                    "participation_id": participation_id,
                    "job_id": job_id,
                    "text_length": len(text or ""),
                },
            )
            print(
                f"[STT] handler_finished participation_id={participation_id} job_id={job_id}",
                flush=True,
            )
            return {"participation_id": participation_id, "text_length": len(text or "")}
        except BackgroundJobPermanentError:
            _mark_participation_failed(participation_id)
            raise
        finally:
            if temp_wav_path and os.path.exists(temp_wav_path):
                try:
                    os.remove(temp_wav_path)
                except OSError:
                    logger.warning(
                        "temp_file_cleanup_failed",
                        extra={
                            "handler_name": "transcription",
                            "participation_id": participation_id,
                            "job_id": job_id,
                        },
                    )


def _mark_participation_failed(participation_id: int) -> None:
    from users.models import Participation

    updated = Participation.objects.filter(id=participation_id).exclude(
        status__in=("user_review", "approved", "rejected")
    ).update(status="failed")
    if updated:
        logger.info(
            "participation_marked_failed",
            extra={"participation_id": participation_id, "status": "failed"},
        )
