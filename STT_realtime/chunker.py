import numpy as np
from .config import audio_q, chunk_q, CHUNK_SIZE, OVERLAP, RATE


# ======= مرحله ۲: تکه‌تکه کردن صدا =======
def start_chunker():
    buffer = np.zeros(0, dtype=np.float32)
    step = int((CHUNK_SIZE - OVERLAP) * RATE)

    while True:
        data = audio_q.get()
        buffer = np.concatenate((buffer, data.flatten()))

        # وقتی طول بافر به اندازه‌ی یک تکه کامل رسید
        while len(buffer) >= CHUNK_SIZE * RATE:
            chunk = buffer[: int(CHUNK_SIZE * RATE)]
            chunk_q.put(chunk.copy())
            buffer = buffer[int(step) :]  # حرکت با overlap
