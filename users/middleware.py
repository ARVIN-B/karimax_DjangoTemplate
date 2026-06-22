# users/middleware.py

from django.shortcuts import redirect
from django.contrib.auth import logout
from django.urls import resolve, Resolver404, reverse
from django.conf import settings


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
    
class ForceLogoutMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # درخواست‌های مربوط به لاگین و لاگاوت را نادیده می‌گیریم (برای جلوگیری از لوپ)
        if request.path in [
            reverse('users:login'),
            reverse('users:logout'),
        ]:
            return self.get_response(request)

        user = request.user
        if user.is_authenticated and getattr(user, 'login_required', False):
            # کاربر را خارج می‌کنیم
            logout(request)
            # می‌توانید یک پیام خطا در session ذخیره کنید تا در صفحه لاگین نمایش داده شود
            request.session['force_logout_message'] = 'نشست شما به دلایل امنیتی پایان یافت. لطفاً دوباره وارد شوید.'
            return redirect('users:login')

        response = self.get_response(request)
        return response
    

class KarimaxPermissionMiddleware:
    """
    کاربرانی که karimax_permision=False دارند، فقط می‌توانند صفحه‌ی لندینگ و
    خروج از حساب را ببینند. سایر مسیرها به صفحه‌ی لندینگ منتقل می‌شوند.
    """

    def __init__(self, get_response):
        self.get_response = get_response
        # لیست view name هایی که کاربر محدود مجاز به دیدن آن‌هاست
        self.allowed_views = getattr(
            settings,
            'KARIMAX_RESTRICTED_ALLOWED_VIEWS'
        )
        self.landing_url = reverse('users:landing')

    def __call__(self, request):
        # فقط کاربران لاگین‌شده و فاقد مجوز را بررسی می‌کنیم
        if request.user.is_authenticated and not request.user.karimax_permision:
            # مسیرهای static و media را نادیده بگیرید تا سایت ظاهر درستی داشته باشد
            if (
                request.path.startswith(settings.STATIC_URL)
                or request.path.startswith(settings.MEDIA_URL)
            ):
                return self.get_response(request)

            # پیدا کردن نام view مربوط به مسیر جاری
            try:
                match = resolve(request.path)
                view_name = match.view_name
                namespace = match.namespace or ''
            except Resolver404:
                # اگر مسیر اصلاً تعریف نشده باشد هم ریدایرکت به لندینگ
                return redirect(self.landing_url)

            # اگر view_name در لیست مجاز نباشد، کاربر را به لندینگ بفرستید
            # if view_name not in self.allowed_views:
            #     return redirect(self.landing_url)
            
            if namespace == 'admin' or view_name.startswith('admin:') or request.path.startswith('/admin/') or view_name in self.allowed_views:
                return self.get_response(request)
            
            return redirect(self.landing_url)

        # برای سایر کاربران (یا مسیرهای مجاز) درخواست به صورت عادی پردازش شود
        return self.get_response(request)