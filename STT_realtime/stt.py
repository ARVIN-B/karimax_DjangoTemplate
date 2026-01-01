import tempfile
import os
import speech_recognition as sr
import soundfile as sf  # ← جایگزین امن برای ذخیره wav
from .config import chunk_q, RATE, recognizer


# ======= مرحله ۳: تشخیص گفتار =======
def start_stt_worker():
    while True:
        chunk = chunk_q.get()
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
            wav_path = f.name
            # ذخیره مطمئن به صورت PCM 16-bit
            sf.write(wav_path, chunk, RATE, subtype="PCM_16")

        try:
            with sr.AudioFile(wav_path) as source:
                audio_data = recognizer.record(source)
                text = recognizer.recognize_google(
                    audio_data, language="fa-IR"
                )  # زبان فارسی
                if text.strip():
                    print(f"🗣️ {text}")
        except sr.UnknownValueError:
            pass  # اگر چیزی تشخیص داده نشد
        except Exception as e:
            print("⚠️ Error:", e)
        finally:
            os.remove(wav_path)
