import threading
import time
from .recorder import start_audio_stream
from .chunker import start_chunker
from .stt import start_stt_worker


def main():

    # ======= اجرای pipeline =======
    threads = [
        threading.Thread(target=start_audio_stream, daemon=True),
        threading.Thread(target=start_chunker, daemon=True),
        threading.Thread(target=start_stt_worker, daemon=True),
    ]

    for t in threads:
        t.start()

    print("🎤 Real-time STT (speech_recognition) در حال اجراست...")
    print("برای خروج Ctrl + C بزنید")

    while True:
        time.sleep(1)


if __name__ == "__main__":
    main()
