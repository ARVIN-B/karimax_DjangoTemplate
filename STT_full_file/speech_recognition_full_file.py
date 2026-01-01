from .to_wav import to_wav_mono_16k
from .transcribe import transcribe_long_audio_with_merge

import time

start_time = time.time()

# in_audio_path = "New_Recording_11.m4a"
# out_audio_path = "New_Recording_11.wav"

def STT_full_file(in_audio_path, out_audio_path, task_id : int = 1):


    to_wav_mono_16k(in_audio_path, out_audio_path)
    audio_file = out_audio_path

    task_id = task_id

    final_text = transcribe_long_audio_with_merge(audio_file, 3, 2, "fa_IR", task_id)

    # with open("transcript_merged.txt", "w", encoding="utf-8") as f:
    #     f.write(final_text)

    # print("\n📄 فایل نهایی در transcript_merged.txt ذخیره شد.")
    return final_text

def STT_full_file_wave(audio_file, save_path = "", task_id = 1):
    start_time_transcribe = time.time()

    final_text = transcribe_long_audio_with_merge(audio_file, 3, 2, "fa_IR", task_id)

    end_time_transcribe = time.time()
    execution_time_transcribe = end_time_transcribe - start_time_transcribe
    print("transcribing time : ", execution_time_transcribe)

    if save_path:
        start_time_save = time.time()
        with open("transcript_merged.txt", "w", encoding="utf-8") as f:
            f.write(final_text)
        end_time_save = time.time()
        execution_time_save = end_time_save - start_time_save
        print("saving time : ", execution_time_save)

        print(f"\n📄 فایل نهایی در {save_path}/transcript_merged.txt ذخیره شد.")

        final_result_text = "پردازش با موفقیت انجام شد"  # متن نهایی را جایگذاری کنید

        # ذخیره نتیجه نهایی و تعیین 100%

    return final_text


end_time = time.time()
execution_time = end_time - start_time

print("execution_time : ", execution_time)

