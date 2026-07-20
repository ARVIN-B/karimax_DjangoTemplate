import os
from pathlib import Path
from decouple import config
from django.contrib.messages import constants as messages

# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent
DJANGO_ENV = config("DJANGO_ENV", default="localhost")

CONTACT_PHONE_NUMBER = "09924876377"
PARSGREEN_SMS_NUMBER = "9998883511"

USER_MANAGEMENT_INITIAL_LOAD_COUNT = 10
USER_MANAGEMENT_LOAD_MORE_COUNT = 5

API_KEY = config("API_KEY")

if DJANGO_ENV == "production":
    # SESSION_COOKIE_DOMAIN = ".karimax2.ir"
    BASE_URL = f"{config("PRODUCT_BASE_URL")}"
    SESSION_COOKIE_DOMAIN = f".{BASE_URL}"
    SESSION_COOKIE_NAME = "sessionid"
    DEBUG = False
elif DJANGO_ENV == "development":
    # SESSION_COOKIE_DOMAIN = ".karimax2.ir"
    BASE_URL = f"{config("DEVELOP_BASE_URL")}"
    SESSION_COOKIE_DOMAIN = f".{BASE_URL}"
    SESSION_COOKIE_NAME = "sessionid"
    DEBUG = True
elif DJANGO_ENV == "localhost":
    BASE_URL = "127.0.0.1"
    DEBUG = True
else:
    BASE_URL = "127.0.0.1"
    DEBUG = True

WEEKS_COUNT = 2

KARIMAX_RESTRICTED_ALLOWED_VIEWS = [
    "users:landing",
    "users:logout",
    "users:contact_us",
]

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = config("SECRET_KEY", default="your-secret-key-here")
# DEBUG = config("DEBUG", default=True, cast=bool)

# DEBUG = False
# DEBUG = True

AXES_ENABLED = False

# برای محیط لوکال، فقط 127.0.0.1 و localhost رو اجازه بده
ALLOWED_HOSTS = [
    "127.0.0.1",
    "localhost",
    "37.255.237.86",
    "www.karimax.ir",
    "karimax.ir",
    "www.dev.karimax2.ir",
    "dev.karimax2.ir",
    "karimax2.ir",
    "www.karimax2.ir",
    f"{BASE_URL}",
    f"www.{BASE_URL}",
    # "www.mymoghadam.ir",
    # "mymoghadam.ir",
]

# Application definition
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",
    # Third party apps
    "crispy_forms",
    "crispy_bootstrap4",
    # Local apps
    "core.infrastructure.apps.InfrastructureConfig",
    # "users",
    "evaluations",
    "axes",
    "django.contrib.humanize",
    "widget_tweaks",
    "users.apps.UsersConfig",
    # "mfa",
]



WEBAUTHN_RP_ID = "dev.karimax2.ir"
WEBAUTHN_RP_NAME = "dev.Karimax"
WEBAUTHN_ORIGIN = "https://dev.karimax2.ir"



# django-axes settings
AXES_COOLOFF_TIME = 0.25  # 15 دقیقه قفل بعد از چند تلاش ناموفق
AXES_FAILURE_LIMIT = 5  # حداکثر 5 تلاش ناموفق
AXES_EXCLUDE_ADMINS = True  # ادمین‌ها از محدودیت‌ها مستثنی می‌شن
AXES_CLIENT_IP = False  # غیرفعال کردن استفاده از IP برای شناسایی تلاش‌ها

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.locale.LocaleMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "users.middleware.KarimaxPermissionMiddleware",
    "users.middleware.FirstLoginMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "axes.middleware.AxesMiddleware",  # اضافه شده برای django-axes
    # 'users.error_handler.GlobalErrorHandlerMiddleware',  # ← این رو اضافه کن
    "users.error_handler.GlobalErrorHandlerMiddleware",
    "users.middleware.ForceLogoutMiddleware",
    "users.middleware.MaintenanceMiddleware",
]


# تنظیمات صفحه بروزرسانی
MAINTENANCE_MODE = False  # این را هر وقت خواستی فعال کن

MAINTENANCE_PATHS = [
    # '/users/submit-participation/',
]


ROOT_URLCONF = "pmss.urls"

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [
            BASE_DIR / "templates",
            BASE_DIR / "users" / "templates",
        ],  # اضافه کردن مسیر users/templates
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
                "django.template.context_processors.csrf",
                "users.context_processors.user_role_context",
                "users.context_processors.global_banner",
                "users.context_processors.notification_context",
            ],
        },
    },
]

WSGI_APPLICATION = "pmss.wsgi.application"

# Database - MariaDB
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": config("DB_NAME", default="pms_db"),
        "USER": config("DB_USER"),
        "PASSWORD": config("DB_PASSWORD"),
        "HOST": config("DB_HOST", default="localhost"),
        "PORT": config("DB_PORT", default="3306"),
        "OPTIONS": {
            "init_command": "SET sql_mode='STRICT_TRANS_TABLES'",
            "charset": "utf8mb4",
        },
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    #    {
    #        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    #    },
    {
        "NAME": "django.contrib.auth.password_validation.MinimumLengthValidator",
        "OPTIONS": {"min_length": 6},
    },
    #    {
    #        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    #    },
    #    {
    #        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    #    },
]

# Internationalization - Persian
LANGUAGE_CODE = "fa-ir"
TIME_ZONE = "Asia/Tehran"
USE_I18N = True
USE_TZ = True

LANGUAGES = [
    ("fa", "فارسی"),
    ("en", "English"),
]

LOCALE_PATHS = [
    BASE_DIR / "locale",
    BASE_DIR / "locale",
]


STATIC_URL = "/static/"
STATICFILES_DIRS = [BASE_DIR / "static"]  # اضافه کن
STATIC_ROOT = BASE_DIR / "staticfiles"  # فقط برای collectstatic


# STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')  # مثلاً pmss/staticfiles
# STATICFILES_DIRS = [os.path.join(BASE_DIR, 'static')]  # فولدر pmss/static رو به عنوان منبع اضافه کنید

MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "media")  # استفاده از os.path.join برای سازگاری

# Default primary key field type
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# Crispy Forms
CRISPY_ALLOWED_TEMPLATE_PACKS = "bootstrap4"
CRISPY_TEMPLATE_PACK = "bootstrap4"

# Authentication
AUTH_USER_MODEL = "users.Employee"
AUTHENTICATION_BACKENDS = [
    "axes.backends.AxesStandaloneBackend",
    "django.contrib.auth.backends.ModelBackend",
]
LOGIN_URL = "/users/login/"  # مسیر درست برای لاگین
LOGIN_REDIRECT_URL = "/users/"
LOGOUT_REDIRECT_URL = "/users/login/"

# Security
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = "DENY"
# SECURE_SSL_REDIRECT = True  # فقط برای تولید با HTTPS (برای توسعه کامنت کن)
# SESSION_COOKIE_SECURE = True  # فقط برای HTTPS (برای توسعه کامنت کن)
# CSRF_COOKIE_SECURE = True  # فقط برای HTTPS (برای توسعه کامنت کن)

# محدودیت برای داده‌های POST (غیرفایل)
DATA_UPLOAD_MAX_MEMORY_SIZE = 314572800  # 300MB (300 * 1024 * 1024)

# محدودیت برای فایل‌های آپلود (فایل‌های کوچک‌تر از این در حافظه لود می‌شن، بزرگ‌تر به دیسک نوشته می‌شن)
FILE_UPLOAD_MAX_MEMORY_SIZE = 314572800  # 300MB

MESSAGE_TAGS = {
    messages.DEBUG: "secondary",
    messages.INFO: "info",
    messages.SUCCESS: "success",
    messages.WARNING: "warning",
    messages.ERROR: "danger",  # مهم! برای رنگ قرمز Bootstrap
}
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
        },
        "file": {
            "class": "logging.FileHandler",
            "filename": "errors.log",
        },
    },
    "root": {
        "handlers": ["console", "file"],
        "level": "ERROR",
    },
    "loggers": {
        "users.middleware": {
            "handlers": ["console", "file"],
            "level": "ERROR",
            "propagate": False,
        },
    },
}


if DEBUG:
    # محیط توسعه: فرانت لوکال، بک‌اند روی سرور
    CORS_ALLOW_ALL_ORIGINS = True
    CORS_ALLOW_CREDENTIALS = True

    # SESSION_COOKIE_SAMESITE = "None"
    # CSRF_COOKIE_SAMESITE = "None"

    # اصلاح شد: برای SameSite=None حتما باید True باشند
    SESSION_COOKIE_SECURE = False
    CSRF_COOKIE_SECURE = False
    SESSION_COOKIE_SAMESITE = "Lax"
    CSRF_COOKIE_SAMESITE = "Lax"

    CSRF_TRUSTED_ORIGINS = [
        "http://localhost:8000",
        "http://127.0.0.1:8000",
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        # "https://api.karimax.ir",
        "https://karimax.ir",
        "https://www.karimax.ir",
        "http://0.0.0.0:8000",
        "http://0.0.0.0:8002",
        "https://www.dev.karimax2.ir",
        "https://dev.karimax2.ir",
        "http://karimax2.ir",
        "http://www.karimax2.ir",
        "https://karimax2.ir",
        "https://www.karimax2.ir",
        "http://www.dev.karimax2.ir",
        "http://dev.karimax2.ir",
        f"https://{BASE_URL}",
        f"https://www.{BASE_URL}",
        # "https://www.mymoghadam.ir",
        # "https://mymoghada.mir",
        # "*"
    ]
    CORS_ALLOW_CREDENTIALS = True
    ALLOWED_HOSTS = ["*"]

else:
    # پروداکشن
    CORS_ALLOW_ALL_ORIGINS = False
    CORS_ALLOWED_ORIGINS = [
        "https://karimax.ir",
        "https://www.karimax.ir",
        "https://karimax2.ir",
        "https://www.karimax2.ir",
        f"https://{BASE_URL}",
        f"https://www.{BASE_URL}",
        # "https://www.mymoghadam.ir",
        # "https://mymoghadam.ir",
        # دامنه نهایی فرانت‌اندت
    ]

    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SAMESITE = "Lax"
    CSRF_COOKIE_SAMESITE = "Lax"

    CSRF_TRUSTED_ORIGINS = [
        "https://karimax.ir",
        "https://www.karimax.ir",
        "https://karimax2.ir",
        "https://www.karimax2.ir",
        "http://www.dev.karimax2.ir",
        "http://dev.karimax2.ir",
        "https://www.dev.karimax2.ir",
        "https://dev.karimax2.ir",
        f"https://{BASE_URL}",
        f"https://www.{BASE_URL}",
        # "https://www.mymoghadam.ir",
        # "https://mymoghadam.ir",
    ]

# CORS_ALLOW_CREDENTIALS = True
# CORS_ALLOW_ALL_ORIGINS = False
#
# CORS_ALLOW_ALL_ORIGINS = True
# CORS_ALLOW_CREDENTIALS = True

CSRF_FAILURE_VIEW = "users.views.csrf_failure"

BACKGROUND_CACHE = config("BACKGROUND_CACHE", default="redis")
BACKGROUND_QUEUE = config("BACKGROUND_QUEUE", default="celery")
BACKGROUND_CACHE_ALIAS = config("BACKGROUND_CACHE_ALIAS", default="default")
BACKGROUND_QUEUE_NAMESPACE = config("BACKGROUND_QUEUE_NAMESPACE", default="background")
BACKGROUND_CACHE_TTL_SECONDS = config("BACKGROUND_CACHE_TTL_SECONDS", default=300, cast=int)
BACKGROUND_QUEUE_POLL_INTERVAL_SECONDS = config(
    "BACKGROUND_QUEUE_POLL_INTERVAL_SECONDS", default=0.2, cast=float
)

def _parse_csv_list(value: str) -> list[str]:
    return [item.strip().strip('"').strip("'") for item in value.strip("[]").split(",") if item.strip()]

CELERY_BROKER_URL = config("CELERY_BROKER_URL", default="redis://127.0.0.1:6379/0")
CELERY_RESULT_BACKEND = config("CELERY_RESULT_BACKEND", default="redis://127.0.0.1:6379/1")
CELERY_TASK_DEFAULT_QUEUE = config("CELERY_TASK_DEFAULT_QUEUE", default="background")
BACKGROUND_QUEUE_TASK_NAME = config(
    "BACKGROUND_QUEUE_TASK_NAME", default="core.infrastructure.tasks.dispatch_background_job"
)
CELERY_TASK_SERIALIZER = config("CELERY_TASK_SERIALIZER", default="json")
CELERY_RESULT_SERIALIZER = config("CELERY_RESULT_SERIALIZER", default="json")
CELERY_ACCEPT_CONTENT = config("CELERY_ACCEPT_CONTENT", default='["json"]', cast=_parse_csv_list)
CELERY_TASK_DEFAULT_RETRY_DELAY_SECONDS = config("CELERY_TASK_DEFAULT_RETRY_DELAY_SECONDS", default=5, cast=int)
CELERY_TASK_MAX_RETRIES = config("CELERY_TASK_MAX_RETRIES", default=5, cast=int)
# STT on long audio can run for hours; keep limits aligned with gunicorn timeout.
CELERY_TASK_SOFT_TIME_LIMIT_SECONDS = config(
    "CELERY_TASK_SOFT_TIME_LIMIT_SECONDS", default=14000, cast=int
)
CELERY_TASK_TIME_LIMIT_SECONDS = config("CELERY_TASK_TIME_LIMIT_SECONDS", default=14400, cast=int)
CELERY_WORKER_PREFETCH_MULTIPLIER = config("CELERY_WORKER_PREFETCH_MULTIPLIER", default=1, cast=int)
CELERY_WORKER_CONCURRENCY = config("CELERY_WORKER_CONCURRENCY", default=1, cast=int)
CELERY_WORKER_LOG_LEVEL = config("CELERY_WORKER_LOG_LEVEL", default="INFO")
CELERY_BROKER_TRANSPORT_OPTIONS_VISIBILITY_TIMEOUT = config(
    "CELERY_BROKER_TRANSPORT_OPTIONS_VISIBILITY_TIMEOUT", default=15000, cast=int
)
BACKGROUND_JOB_RETENTION_DAYS = config("BACKGROUND_JOB_RETENTION_DAYS", default=30, cast=int)
REDIS_CACHE_URL = config("REDIS_CACHE_URL", default="redis://127.0.0.1:6379/2")

CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": REDIS_CACHE_URL,
    }
}
