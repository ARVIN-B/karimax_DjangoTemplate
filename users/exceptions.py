class STTError(Exception):
    """خطای عمومی تبدیل گفتار به متن"""
    pass


class STTConnectionError(STTError):
    """خطای ارتباط با سرویس STT"""
    pass


class STTRecognitionError(STTError):
    """خطا در تشخیص گفتار"""
    pass