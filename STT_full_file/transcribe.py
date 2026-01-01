import speech_recognition as sr
import tempfile
from pydub import AudioSegment
import time
import math

from .merge_llm import merge_with_llm
from .preprocess_for_remove_duplicate import get_last_sentence_for_merge


def transcribe_long_audio_with_merge(
    audio_path, chunk_minutes=2, overlap_seconds=2, language="fa-IR", task_id=1
):
    chunk_ms = chunk_minutes * 60 * 1000
    recognizer = sr.Recognizer()

    audio = AudioSegment.from_file(audio_path)
    duration_ms = len(audio)
    print(f"⏱ audio duration {duration_ms / (60*1000):.2f} min")

    chunk_length_ms = chunk_minutes * 60 * 1000
    overlap_ms = overlap_seconds * 1000

    full_text = ""
    prev_main = ""
    start = 0
    index = 1

    em = math.ceil(chunk_length_ms / chunk_ms)

    per = 100 / (em * 2)
    percent = 0

    max_tries = 3
    tries = 0

    while (start < duration_ms) and (tries < max_tries):
        end = start + chunk_length_ms + overlap_ms
        if end > duration_ms:
            end = duration_ms

        if start != 0:
            start -= overlap_ms

        dur = (end - start) / 1000
        if dur < 5:
            break

        chunk = audio[start:end]
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
            chunk.export(f.name, format="wav")
            wav_path = f.name

        try:
            with sr.AudioFile(wav_path) as source:
                audio_data = recognizer.record(source)
                print(f"part : {index} is sent to voice detection")

                start_time = time.time()
                ####################
                new_text = recognizer.recognize_google(audio_data, language=language)

                percent = percent + per

                ####################
                end_time = time.time()
                execution_time = end_time - start_time
                print(
                    f"part : {index}'s recognize_google deuration is : {execution_time}"
                )

                if new_text.strip():
                    print(f"🟢 part {index} recognized")
                    # if full_text.strip() == "":
                    #     full_text += new_text
                    # else:
                    start_time = time.time()

                    # --- پیدا کردن آخرین جمله قابل اتصال ---
                    prev_main, overlap_part = get_last_sentence_for_merge(full_text)
                    ####################
                    # --- ادغام با LLM ---
                    merged_segment = merge_with_llm(overlap_part, new_text)

                    percent = percent + per

                    ####################
                    if full_text.strip() == "":
                        full_text += merged_segment.strip()
                    else:
                        # --- ترکیب نهایی ---
                        full_text = prev_main.strip() + "، " + merged_segment.strip()

                    end_time = time.time()
                    execution_time = end_time - start_time
                    print(f"part : {index}'s llm duration time is : {execution_time}")

        except sr.UnknownValueError:
            print(f"part {index}: voice is not recognizable")
            start = (index - 1) * chunk_length_ms
            tries += 1
            continue
        except sr.RequestError as e:
            print(f"service error: {e}")
            start = (index - 1) * chunk_length_ms
            tries += 1
            continue
        # finally:
        #     os.remove(wav_path)

        index += 1
        tries = 0

        if start == 0:
            start += chunk_length_ms
        else:
            start += chunk_length_ms + overlap_ms

    print("\n✅ Done.")
    return full_text
