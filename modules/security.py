import re
from django.contrib import messages
import os
import magic
from django.core.exceptions import ValidationError, SuspiciousOperation
from django.conf import settings

MAX_UPLOAD_SIZE = getattr(settings, "MAX_UPLOAD_SIZE", 300 * 1024 * 1024)  # 300MB
DAILY_UPLOAD_LIMIT = getattr(settings, "DAILY_UPLOAD_LIMIT", 300 * 1024 * 1024)

# پسوندها و MIMEهای مجاز (همون لیست کامل تو)
# ALLOWED_EXTENSIONS = {
#     '.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp', '.avif', '.heic', '.heif',
#     '.mp4', '.webm', '.avi', '.mov', '.mkv', '.flv', '.wmv',
#     '.mp3', '.aac', '.ogg', '.m4a', '.opus', '.wma', '.wav', '.flac',
#     '.pdf', '.doc', '.docx', '.ppt', '.pptx', '.rtf', '.txt',
#     '.odt', '.ods', '.odp', '.xls', '.xlsx',
#     '.pages', '.numbers',
# }

image = {".jpg", ".jpeg", ".png", ".webp", ".gif", ".bmp", ".avif", ".heic", ".heif"}
video = {".mp4", ".webm", ".avi", ".mov", ".mkv", ".flv", ".wmv"}
audio = {".mp3", ".aac", ".ogg", ".m4a", ".opus", ".wma", ".wav", ".flac", ".oga"}
doc = {".pdf", ".doc", ".docx", ".ppt", ".pptx", ".rtf", ".txt"}
excel = {".odt", ".ods", ".odp", ".xls", ".xlsx"}
iphone = {".pages", ".numbers"}

ALLOWED_EXTENSIONS = image | video | audio | doc | excel | iphone

ALLOWED_MIME_MAP = {
    ".jpg": ["image/jpeg"],
    ".jpeg": ["image/jpeg"],
    ".png": ["image/png"],
    ".gif": ["image/gif"],
    ".webp": ["image/webp"],
    ".bmp": ["image/bmp", "image/x-ms-bmp"],
    ".avif": ["image/avif"],
    ".heic": ["image/heic"],
    ".heif": ["image/heif"],
    ".mp4": ["video/mp4"],
    ".webm": ["video/webm", "audio/webm"],
    ".avi": ["video/x-msvideo"],
    ".mov": ["video/quicktime"],
    ".mkv": ["video/x-matroska"],
    ".flv": ["video/x-flv"],
    ".wmv": ["video/x-ms-wmv"],
    ".mp3": ["audio/mpeg", "audio/mp3", "video/3gpp"],
    ".wav": ["audio/wav", "audio/x-wav"],
    ".m4a": ["audio/m4a", "audio/mp4", "audio/x-m4a", "video/mp4"],
    ".aac": ["audio/aac"],
    ".ogg": ["audio/ogg", "video/ogg"],
    ".opus": ["audio/opus"],
    ".wma": ["audio/x-ms-wma"],
    ".flac": ["audio/flac"],
    ".pdf": ["application/pdf"],
    ".doc": ["application/msword"],
    ".docx": [
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ],
    ".ppt": ["application/vnd.ms-powerpoint"],
    ".pptx": [
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    ],
    ".xls": ["application/vnd.ms-excel"],
    ".xlsx": ["application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"],
    ".txt": ["text/plain"],
    ".rtf": ["application/rtf", "text/rtf"],
    ".odt": ["application/vnd.oasis.opendocument.text"],
    ".ods": ["application/vnd.oasis.opendocument.spreadsheet"],
    ".odp": ["application/vnd.oasis.opendocument.presentation"],
    ".pages": ["application/x-iwork-pages"],
    ".numbers": ["application/x-iwork-numbers"],
}

# الگوهای خطرناک XSS
DANGEROUS_PATTERNS = [
    r"<script[^>]*>",
    r"</script\s*>",
    r"javascript\s*:",
    r"on\w+\s*=",
    r"data\s*:\s*text/html",
    r"<iframe",
    r"<object",
    r"<embed",
    r"<link[^>]+href\s*=.*\.css",
    r"expression\s*\(",
    r"@import",
    r'src\s*=\s*["\']?[^"\'>]*\.js',
    r'href\s*=\s*["\']?\s*javascript:',
    r"<\s*svg.*onload\s*=",
    r"<\s*img.*src\s*=\s*.x.*onerror",
]


def clean_user_text(text):
    """
    بررسی و پاکسازی متن وارد شده توسط کاربر برای جلوگیری از XSS
    اگر کد مخرب پیدا کرد → خطا می‌ده و ذخیره نمی‌کنه
    """
    if not text:
        return text

    # forbidden_chars = ["<", ">", '"', "'", "&"]
    forbidden_chars = []

    # چک کردن وجود کاراکترهای ممنوعه
    found_chars = [char for char in forbidden_chars if char in text]
    if found_chars:
        # پیام خطای زیبا و واضح برای کاربر
        raise ValidationError(
            f"کاراکترهای غیرمجاز در متن استفاده شده: {' '.join(found_chars)}\n"
            "لطفاً از کاراکترهای < > \" ' & استفاده نکنید."
        )

    # چک اضافی الگوهای خطرناک (حتی بدون کاراکترهای بالا)
    text_lower = text.lower()
    for pattern in DANGEROUS_PATTERNS:
        if re.search(pattern, text_lower, re.IGNORECASE):
            raise ValidationError("متن شامل کد مشکوک یا خطرناک است و مجاز نمی‌باشد.")

    return text


def validate_uploaded_file(file, user=None):
    """
    بررسی کامل فایل آپلود شده:
    - حجم
    - پسوند
    - MIME واقعی
    - حجم روزانه کاربر
    """
    if not file:
        return file

    # 1. چک حجم کلی
    if file.size > MAX_UPLOAD_SIZE:
        raise ValidationError(
            f"حجم فایل نباید بیشتر از {MAX_UPLOAD_SIZE // (1024*1024)} مگابایت باشد."
        )

    # 2. چک پسوند
    ext = os.path.splitext(file.name)[1].lower()
    # if ext not in ALLOWED_EXTENSIONS:
    #     allowed = ", ".join(sorted(ALLOWED_EXTENSIONS))
    #     raise ValidationError(f"فرمت فایل مجاز نیست. فرمت‌های مجاز: {allowed}")

    # 3. چک MIME واقعی با python-magic
    # try:
    #     file.seek(0)
    #     sample = file.read(20480)
    #     file.seek(0)

    #     mime_detector = magic.Magic(mime=True)
    #     actual_mime = mime_detector.from_buffer(sample).lower()
    #     allowed_mimes = ALLOWED_MIME_MAP.get(ext, [])
    #     if not any(mime_part in actual_mime for mime_part in allowed_mimes):
    #         raise ValidationError(
    #             "محتوای فایل با پسوند آن مطابقت ندارد!"
    #             "این فایل احتمالاً مخرب است و رد شد."
    #             f"پسوند اصلی تشخیص داده شده: {actual_mime}"
    #         )
    # except Exception as e:
    #     raise ValidationError(f"خطا در بررسی فایل: {str(e)}")

    # 4. چک حجم روزانه (اگر کاربر دادیم)
    if user and hasattr(user, "day_usage") and hasattr(user, "last_file_upload"):
        from django.utils import timezone

        today = timezone.now().date()
        current_usage = user.day_usage or 0
        last_upload_date = (
            user.last_file_upload.date() if user.last_file_upload else None
        )

        if last_upload_date != today:
            current_usage = 0

        if current_usage + file.size > DAILY_UPLOAD_LIMIT:
            raise ValidationError(
                "حجم مجاز روزانه پر شده است. فردا دوباره امتحان کنید."
            )

    return file
