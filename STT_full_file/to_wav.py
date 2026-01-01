from pydub import AudioSegment


def to_wav_mono_16k(in_path: str, out_path: str):
    audio = AudioSegment.from_file(in_path)  # pydub تشخیص فرمت را انجام می‌دهد
    audio = audio.set_frame_rate(16000).set_channels(1).set_sample_width(2)
    audio.export(out_path, format="wav")
