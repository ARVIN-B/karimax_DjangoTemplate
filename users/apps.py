import os
import threading
import time
import logging

from django.conf import settings
from django.apps import AppConfig
from django.db import connection


def acquire_startup_lock(lock_name: str = "karimax_startup") -> bool:
    """
    فقط اولین Process موفق به گرفتن Lock می‌شود.

    این Lock تا زمانی که Process زنده باشد توسط MariaDB نگهداری می‌شود
    و بعد از خاموش شدن Gunicorn یا سرور به صورت خودکار آزاد می‌شود.
    """
    with connection.cursor() as cursor:
        cursor.execute("SELECT GET_LOCK(%s, 0)", [lock_name])
        result = cursor.fetchone()

    return bool(result and result[0] == 1)


class UsersConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "users"
    verbose_name = "مدیریت کاربران"

    def ready(self):

        if getattr(settings, "DJANGO_ENV", "").lower() != "production":
            return

        def notify():
            try:
                # صبر برای آماده شدن کامل Django و Database
                time.sleep(5)

                # فقط اولین Worker ادامه می‌دهد
                if not acquire_startup_lock():
                    return

                from users.models import Employee
                from users.services.sms import send_sms_to_employees

                employee = Employee.objects.filter(phone_number="09136304789").first()

                if employee:
                    send_sms_to_employees(
                        employee,
                        f"""تست سامانه اعلان""",
                    )

            except Exception:
                # هیچ وقت اجازه نده آماده شدن Django به خاطر این بخش Fail شود.
                logger = logging.getLogger(__name__)
                logger.exception("Startup notification failed.")

        threading.Thread(
            target=notify,
            daemon=True,
            name="startup-notifier",
        ).start()
