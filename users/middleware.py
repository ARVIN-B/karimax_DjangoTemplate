# users/middleware.py

from django.shortcuts import redirect
from django.urls import reverse


class FirstLoginMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

        # ✅ مسیرهای مجاز: کاربر مجبور است در این صفحات بماند.
        self.allowed_urls = [
            reverse('users:change_password'),  # صفحه تغییر رمز عبور
            reverse('users:logout'),  # صفحه خروج
        ]

    def __call__(self, request):

        # 1. بررسی شرط اصلی: فقط برای کاربران احراز هویت شده
        if request.user.is_authenticated:

            # 2. بررسی وضعیت is_first_login
            if request.user.is_first_login:

                # 3. آدرس فعلی درخواست
                current_path = request.path

                # ✅ چک می‌کنیم که آیا کاربر در یکی از مسیرهای مجاز (تغییر رمز یا خروج) هست یا خیر
                is_allowed_url = False
                for url in self.allowed_urls:
                    # استفاده از startswith برای پوشش دهی آدرس‌هایی که با / تمام نمی‌شوند
                    if current_path.startswith(url):
                        is_allowed_url = True
                        break

                # اگر کاربر در صفحه مجاز نیست، به صفحه تغییر رمز هدایت می‌شود.
                if not is_allowed_url:
                    # اطمینان حاصل کنید که آدرس 'users:change_password' در urls.py تعریف شده است.
                    return redirect('users:change_password')

        # اگر کاربر احراز هویت نشده، یا is_first_login = False باشد، درخواست ادامه می‌یابد
        response = self.get_response(request)
        return response