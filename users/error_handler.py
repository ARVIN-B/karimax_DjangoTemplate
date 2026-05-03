# users/middleware.py
import json
from django.http import JsonResponse
from django.core.exceptions import ValidationError
from django.db import IntegrityError
from django.contrib import messages
from django.shortcuts import redirect


class GlobalErrorHandlerMiddleware:
    """میان‌افزار سراسری برای هندل کردن تمام خطاها"""

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        response = self.get_response(request)
        return response

    def process_exception(self, request, exception):
        """این متد همه ارورهای هندل‌نشده رو می‌گیره"""

        # اگر درخواست AJAX هست
        if request.headers.get("X-Requested-With") == "XMLHttpRequest":
            return self._handle_ajax_error(request, exception)
        else:
            # برای درخواست‌های معمولی
            return self._handle_normal_error(request, exception)

    def _handle_ajax_error(self, request, exception):
        """ارورهای AJAX رو به صورت JSON برمی‌گردونه"""
        status_code = 500
        message = "خطای داخلی سرور رخ داد."

        if isinstance(exception, ValidationError):
            status_code = 400
            if hasattr(exception, "messages"):
                message = (
                    exception.messages[0] if exception.messages else str(exception)
                )
            elif hasattr(exception, "message"):
                message = str(exception.message)
            else:
                message = str(exception)

        elif isinstance(exception, IntegrityError):
            status_code = 400
            message = "خطای یکپارچگی داده‌ها. احتمالاً اطلاعات تکراری است."

        elif isinstance(exception, PermissionError):
            status_code = 403
            message = "شما دسترسی انجام این عملیات را ندارید."

        elif isinstance(exception, ValueError):
            status_code = 400
            message = str(exception)

        return JsonResponse(
            {
                "success": False,
                "message": message,
                "detail": str(exception),
            },
            status=status_code,
        )

    def _handle_normal_error(self, request, exception):
        """ارورهای معمولی رو با messages و ریدایرکت هندل می‌کنه"""
        if isinstance(exception, ValidationError):
            if hasattr(exception, "messages"):
                msg = exception.messages[0] if exception.messages else str(exception)
            elif hasattr(exception, "message"):
                msg = str(exception.message)
            else:
                msg = str(exception)
            messages.error(request, msg)

        elif isinstance(exception, IntegrityError):
            messages.error(request, "خطای یکپارچگی داده‌ها.")

        elif isinstance(exception, PermissionError):
            messages.warning(request, "شما دسترسی انجام این عملیات را ندارید.")

        else:
            messages.error(request, "خطای داخلی سرور. لطفاً با پشتیبانی تماس بگیرید.")

        # ریدایرکت به صفحه قبل یا داشبورد
        referer = request.META.get("HTTP_REFERER")
        if referer:
            return redirect(referer)
        return redirect("/")
