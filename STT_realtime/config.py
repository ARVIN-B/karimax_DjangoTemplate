import queue
import speech_recognition as sr

# ===== تنظیمات عمومی =====
RATE = 16000
BLOCK_DURATION = 0.5
CHUNK_SIZE = 3
OVERLAP = 0.5
DEVICE = None

# ===== صف‌های اشتراکی =====
audio_q = queue.Queue()
chunk_q = queue.Queue()
text_q = queue.Queue()

# ===== ماژول تشخیص =====
recognizer = sr.Recognizer()
