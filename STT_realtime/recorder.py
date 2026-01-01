import sounddevice as sd
import time
from .config import RATE, DEVICE, audio_q


# ======= مرحله ۱: ضبط صدا =======
def audio_callback(indata, frames, time_info, status):
    if status:
        print(status)
    audio_q.put(indata.copy())


def start_audio_stream():
    with sd.InputStream(
        samplerate=RATE, channels=1, callback=audio_callback, device=DEVICE
    ):
        while True:
            time.sleep(0.1)
