import jdatetime
import mimetypes
import sys
import pandas as pd

from django.db import transaction
from django.contrib.sessions.models import Session
from django.contrib.admin.views.decorators import staff_member_required
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib.auth import update_session_auth_hash
from django.contrib.auth.password_validation import validate_password
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth.hashers import make_password
from django import forms
from django.conf import settings
from django.urls import reverse

from modules.import_users import import_employees_from_excel
from modules.security import clean_user_text
from modules import security
from modules.excel_export import export_to_excel
from django.views.decorators.http import require_POST

from django.contrib import messages
from django.http import (
    HttpResponse,
    JsonResponse,
    FileResponse,
    Http404,
    HttpResponseBadRequest,
)
from django.db.models import Max, Q, Sum, Avg, Count
from django.core.exceptions import (
    PermissionDenied,
    SuspiciousOperation,
    ValidationError,
    ObjectDoesNotExist,
)
from django.core.paginator import Paginator
import json

from .models import (
    Employee,
    Participation,
    Factory,
    Department,
    Role,
    Evaluation,
    Holding,
    Subdepartment,
    WeeklyMenu,
    MenuItem,
    FoodItem,
    FoodReservation,
    participation_upload_path,
    default_close_food_res_time_H,
    default_close_food_res_time_M,
    start_today_food_comment_time_H,
    start_today_food_comment_time_M,
    OrgUnit,
    Referral,
    ReferralStep,
    Notification,
    NotificationRead,
    Dependent,
    Gender,
    RelativeType,
    DependencyStatus,
    MaritalStatus,
    EmploymentType,
    JobGroup,
    Country,
    Banks,
    BankAccountType,
    BankAccount,
    ContactInfo,
    PreviousInsurer,
    Employee_Bimeh,
    BaseInsurance,
)

from .forms import (
    ParticipationForm,
    ManagementFilterForm,
    UserDetailsFilterForm,
    EvaluationFilterForm,
    CustomPasswordChangeForm,
    EmployeeImportForm,
)
from datetime import datetime, timedelta, time, date
import speech_recognition as sr
import os
import requests
from STT_full_file.speech_recognition_full_file import STT_full_file_wave, STT_full_file
from text_summarizer.text_summarizer import summarizer
from save_to_word_pdf.save_w_p import save_as_word, save_as_pdf
from chat_bot.chat_bot import chat_with_bot

from django.utils import timezone
from django.utils.crypto import get_random_string
from urllib.parse import quote

from django.core.serializers.json import DjangoJSONEncoder
import json
from autogen_agentchat.messages import TextMessage
from collections import defaultdict
import re

if sys.platform == "win32":
    os.system("chcp 65001 >nul")  # تغییر کدپیج کنسول به UTF-8

    # تنظیم مجدد خروجی پایتون
    if sys.stdout.encoding != "utf-8":
        sys.stdout.reconfigure(encoding="utf-8")


PARTICIPATIONS_PER_LOAD = 1000
BASE_COST_PER_PARTICIPATION = 500000
PARSGREEN_SEND_SMS_URL = "https://sms.parsgreen.ir/Apiv2/Message/SendSms"
PARSGREEN_SEND_OTP_URL = "https://sms.parsgreen.ir/Apiv2/Message/SendOtp"
PARSGREEN_DEFAULT_API_KEY = "0E1A21CA-3729-40DD-A37C-387E3CB5982C"
FORGOT_PASSWORD_SESSION_KEY = "forgot_password_otp_state"
FORGOT_PASSWORD_VERIFIED_SESSION_KEY = "forgot_password_verified_state"
FORGOT_PASSWORD_OTP_EXPIRE_SECONDS = 180
FORGOT_PASSWORD_VERIFIED_EXPIRE_SECONDS = 600


LOGIN_OTP_SESSION_KEY = "login_otp"
LOGIN_OTP_EXPIRE_SECONDS = 120  # 2 دقیقه
MAX_OTP_ATTEMPTS = 5


def manifest(request):
    manifest_path = os.path.join(settings.BASE_DIR, "manifest.json")

    return FileResponse(
        open(manifest_path, "rb"), content_type="application/manifest+json"
    )


def assetlinks(request):
    data = [
        {
            "relation": ["delegate_permission/common.handle_all_urls"],
            "target": {
                "namespace": "android_app",
                "package_name": "ir.karimax2.twa",
                "sha256_cert_fingerprints": [
                    "2E:9B:A1:DE:EE:65:1F:2E:F6:57:B5:FF:11:23:9B:F0:23:84:21:0F:E5:E9:EB:DF:BA:D4:6D:15:70:50:4C:14"
                ],
            },
        }
    ]

    return JsonResponse(data, safe=False)


def csrf_failure(request, reason=""):
    """مدیریت ساده ارور CSRF - بدون تمپلیت جدید"""

    # اگر درخواست از صفحه لاگین باشد
    if "login" in request.path.lower():
        return redirect("users:landing")

    # برای صفحات دیگر، رفتار پیش‌فرض Django
    from django.views.csrf import csrf_failure as default_csrf_failure

    return default_csrf_failure(request, reason)


def _resolve_login_backend(user):
    backend = getattr(user, "backend", None)
    if backend:
        return backend

    configured_backends = list(getattr(settings, "AUTHENTICATION_BACKENDS", []) or [])
    model_backend = "django.contrib.auth.backends.ModelBackend"
    if model_backend in configured_backends:
        return model_backend

    if configured_backends:
        return configured_backends[0]

    return model_backend


def _login_user_and_initialize_session(request, user):
    login(request, user, backend=_resolve_login_backend(user))

    management_tree = build_management_tree(user)
    request.session["management_tree"] = management_tree

    if "current_role" in request.session or not user.roles.exists():
        return

    role_priority = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
        "employee",
    ]
    user_role_names = set(user.roles.values_list("name", flat=True))
    selected_role_name = next((r for r in role_priority if r in user_role_names), None)

    if not selected_role_name:
        request.session["current_role"] = None
        request.session["current_holding_id"] = None
        request.session["current_factory_id"] = None
        request.session["current_department_id"] = None
        request.session["current_subdepartment_id"] = None
        request.session["current_is_committee"] = False
        request.session["current_real_role"] = None
        return

    holding_id = None
    factory_id = None
    department_id = None
    subdepartment_id = None
    is_committee = False
    real_role = None

    if selected_role_name == "holding_manager":
        holding = Holding.objects.filter(managers=user).first()
        if holding:
            holding_id = holding.id
    elif selected_role_name == "factory_manager":
        factory = Factory.objects.filter(managers=user).first()
        if factory:
            factory_id = factory.id
            holding_id = factory.holding.id if factory.holding else None
            is_committee = factory.is_committee

    elif selected_role_name == "department_manager":

        # MARK: committee todo
        department = Department.objects.filter(
            Q(managers=user) | Q(manager_2=user) | Q(manager_3=user)
        ).first()
        # MARK: committee todo end

        if department:
            department_id = department.id
            factory_id = department.factory.id
            holding_id = (
                department.factory.holding.id if department.factory.holding else None
            )
            is_committee = department.is_committee

            # MARK: committee todo
            if department.managers.filter(id=user.id).exists():
                real_role = "department_manager"
            elif department.manager_2 == user:
                real_role = "department_manager_2"
            elif department.manager_3 == user:
                real_role = "department_manager_3"
            # MARK: committee todo end

    elif selected_role_name == "supervisor":
        subdepartment = Subdepartment.objects.filter(Q(supervisors=user)).first()
        if subdepartment:
            subdepartment_id = subdepartment.id
            department_id = subdepartment.department.id
            factory_id = subdepartment.department.factory.id
            holding_id = (
                subdepartment.department.factory.holding.id
                if subdepartment.department.factory.holding
                else None
            )
            is_committee = subdepartment.is_committee
    elif selected_role_name == "employee":
        subdepartment = user.assigned_subdepartments.first()
        if subdepartment:
            subdepartment_id = subdepartment.id
            department_id = subdepartment.department.id
            factory_id = subdepartment.department.factory.id
            holding_id = (
                subdepartment.department.factory.holding.id
                if subdepartment.department.factory.holding
                else None
            )

    request.session["current_role"] = selected_role_name
    request.session["current_holding_id"] = holding_id
    request.session["current_factory_id"] = factory_id
    request.session["current_department_id"] = department_id
    request.session["current_subdepartment_id"] = subdepartment_id
    request.session["current_is_committee"] = bool(is_committee)
    request.session["current_real_role"] = real_role if real_role else None


def perform_login(request, user):

    if user.login_required:
        user.login_required = False
        user.save(update_fields=["login_required"])

    _login_user_and_initialize_session(request, user)

    try:
        role_name = request.session["current_role"]

    except Exception as e:
        messages.error(
            request,
            f"برای شما محل فعالیت و نقش تعریف نشده است ، لطفا با پشتیبانی تماس حاصل فرمایید. شماره تماس پشتیبانی : {settings.CONTACT_PHONE_NUMBER}",
        )
        return logout_view(request)

    if not role_name or role_name == "":

        messages.error(
            request,
            f"برای شما محل فعالیت و نقش تعریف نشده است ، لطفا با پشتیبانی تماس حاصل فرمایید. شماره تماس پشتیبانی : {settings.CONTACT_PHONE_NUMBER}",
        )
        return logout_view(request)

    if role_name in {
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    }:
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر هفته ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    elif role_name == "supervisor":
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر هفته ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    elif role_name == "employee":
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر ماه ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    # return redirect("users:dashboard")
    return redirect("users:landing")


def authenticate_user(request):
    national_id = request.POST.get("national_id")
    password = request.POST.get("password")  # ممکن است خالی باشد
    otp_code = request.POST.get("otp_code")  # ممکن است خالی باشد

    u = Employee.objects.filter(national_id=national_id).first()

    if not u.is_active:
        return (
            None,
            f"حساب کاربری شما غیرفعال است، لطفا با واحد هوش مصنوعی تماس حاصل فرمایید. شماره تماس پشتیبانی : {settings.CONTACT_PHONE_NUMBER}",
        )

    if otp_code:
        # ورود با OTP
        # user, error_msg = _verify_otp(request, national_id, otp_code)
        return _verify_otp(request, national_id, otp_code)

    # ورود با رمز عبور
    user = authenticate(request, username=national_id, password=password)

    if user is None:
        return None, "کد ملی یا رمز عبور اشتباه است."

    return user, None


# import json
# import base64
# from django.http import JsonResponse
# from django.views.decorators.csrf import csrf_exempt
# from webauthn import (
#     generate_authentication_options,
#     options_to_json,
#     verify_authentication_response,   # ← این خط خیلی مهمه!
# )
# from webauthn.helpers import bytes_to_base64url
# from webauthn.helpers.structs import UserVerificationRequirement


# @csrf_exempt
# def passkey_begin(request):
#     """شروع احراز هویت Passkey"""

#     # دریافت national_id
#     if request.content_type == "application/json":
#         try:
#             data = json.loads(request.body)
#             national_id = data.get("national_id")
#         except:
#             national_id = None
#     else:
#         national_id = request.POST.get("national_id")

#     if not national_id or len(str(national_id)) != 10:
#         return JsonResponse({"success": False, "error": "کد ملی نامعتبر است"}, status=400)

#     try:
#         user = Employee.objects.get(national_id=national_id)
#     except User.DoesNotExist:
#         return JsonResponse({"success": False, "error": "کاربر یافت نشد"})

#     # تولید گزینه‌های WebAuthn
#     options = generate_authentication_options(
#         rp_id=request.get_host().split(':')[0],
#         allow_credentials=[
#             {"type": "public-key", "id": bytes_to_base64url(pk.credential_id)}
#             for pk in user.passkeys.all()
#         ],
#         user_verification=UserVerificationRequirement.PREFERRED,
#     )

#     # ✅ تبدیل bytes به base64 قبل از ذخیره در session
#     challenge_b64 = base64.b64encode(options.challenge).decode('ascii')

#     request.session['webauthn_challenge'] = challenge_b64
#     request.session['webauthn_user_id'] = user.id
#     request.session.modified = True

#     # تبدیل options به JSON قابل قبول
#     options_dict = json.loads(options_to_json(options))

#     return JsonResponse({
#         "success": True,
#         "publicKey": options_dict
#     })


# import base64

# @csrf_exempt
# def passkey_complete(request):
#     """تکمیل لاگین با Passkey"""
#     if request.content_type != "application/json":
#         return JsonResponse({"success": False, "error": "JSON required"}, status=400)

#     try:
#         data = json.loads(request.body)
#         national_id = data.get("national_id")
#         credential = data.get("credential")
#     except Exception:
#         return JsonResponse({"success": False, "error": "Invalid JSON"}, status=400)

#     if not national_id or not credential:
#         return JsonResponse({"success": False, "error": "اطلاعات ناقص"}, status=400)

#     try:
#         user = Employee.objects.get(national_id=national_id)

#         # بازیابی challenge
#         challenge_b64 = request.session.get('webauthn_challenge')
#         if not challenge_b64:
#             return JsonResponse({"success": False, "error": "Session expired"})

#         challenge = base64.b64decode(challenge_b64)

#         session_user_id = request.session.get('webauthn_user_id')
#         if user.id != session_user_id:
#             return JsonResponse({"success": False, "error": "Session invalid"})

#         # پیدا کردن Passkey کاربر
#         raw_credential_id = base64.b64decode(credential.get("rawId"))
#         passkey = user.passkeys.get(credential_id=raw_credential_id)

#         # بررسی پاسخ
#         verification = verify_authentication_response(
#             credential=credential,
#             expected_challenge=challenge,
#             expected_rp_id=request.get_host().split(':')[0],
#             expected_origin=request.build_absolute_uri('/')[:-1],
#             credential_public_key=passkey.public_key,
#             credential_sign_count=passkey.sign_count,
#             require_user_verification=True,
#         )

#         # به‌روزرسانی شمارنده
#         passkey.sign_count = verification.new_sign_count
#         passkey.last_used_at = timezone.now()  # اگر فیلد داری
#         passkey.save()

#         perform_login(request, user)

#         # پاک کردن session
#         request.session.pop('webauthn_challenge', None)
#         request.session.pop('webauthn_user_id', None)

#         return JsonResponse({"success": True})

#     except User.DoesNotExist:
#         return JsonResponse({"success": False, "error": "User not found"})
#     except Exception as e:
#         return JsonResponse({"success": False, "error": str(e)})


def login_view(request):
    national_id = request.POST.get("national_id")
    password = request.POST.get("password")  # ممکن است خالی باشد
    otp_code = request.POST.get("otp_code")  # ممکن است خالی باشد

    if request.user.is_authenticated:
        # return redirect("users:dashboard")
        return redirect("users:landing")

    if request.method == "POST":
        if request.user.is_authenticated:
            return redirect("users:landing")

        user, error_msg = authenticate_user(request)

        if user is not None:

            perform_login(request, user)

            # has_passkey = user.passkeys.exists()

            # return render(request, "users/login.html", {
            #     "has_passkey": has_passkey,
            #     "national_id": national_id,   # برای پیش‌فرض کردن فیلد
            # })

            return redirect("users:landing")

        messages.error(request, error_msg or "خطا در ورود.")

    # return render(request, "users/login.html")
    return render(
        request,
        "users/login.html",
        {
            "next": request.GET.get("next", ""),
        },
    )


def register_view(request):

    if request.user.is_authenticated:
        return redirect("users:landing")

    if request.method != "POST":
        return redirect("users:login")

    first_name = request.POST.get("first_name", "").strip()
    last_name = request.POST.get("last_name", "").strip()
    phone = request.POST.get("phone", "").strip()
    password = request.POST.get("password", "").strip()
    national_id = request.POST.get("national_id", "").strip()

    # validations
    if not first_name:
        messages.error(request, "نام الزامی است.")
        return redirect("users:login")

    if not last_name:
        messages.error(request, "نام خانوادگی الزامی است.")
        return redirect("users:login")

    if not national_id or len(national_id) != 10:
        messages.error(request, "کد ملی معتبر نیست.")
        return redirect("users:login")

    if not phone.startswith("09") or len(phone) != 11:
        messages.error(request, "شماره موبایل معتبر نیست.")
        return redirect("users:login")

    if len(password) < 6:
        messages.error(request, "رمز عبور باید حداقل ۶ کاراکتر باشد.")
        return redirect("users:login")

    if Employee.objects.filter(national_id=national_id).exists():
        messages.error(request, "کاربری با این کد ملی وجود دارد.")
        return redirect("users:login")

    # create user
    user = Employee.objects.create_user(
        username=national_id,
        national_id=national_id,
        first_name=first_name,
        last_name=last_name,
        phone_number=phone,
        password=password,
    )
    employee_role = Role.objects.filter(name="employee").first()

    if employee_role:
        user.roles.add(employee_role)

    user.karimax_permision = False
    user.is_active = True
    user.is_first_login = False
    user.save()

    # login کامل سیستم
    perform_login(request, user)

    messages.success(request, "ثبت‌نام با موفقیت انجام شد.")

    return redirect("users:landing")


@require_POST
def send_otp_login(request):
    national_id = (request.POST.get("national_id") or "").strip()
    if not re.fullmatch(r"\d{10}", national_id):
        return JsonResponse(
            {"ok": False, "message": "کد ملی باید ۱۰ رقم باشد."}, status=400
        )

    # کاربر فعال را پیدا کن
    employee = Employee.objects.filter(national_id=national_id, is_active=True).first()
    if not employee:
        return JsonResponse(
            {"ok": False, "message": "کاربری با این کد ملی یافت نشد."}, status=404
        )

    raw_phone = (employee.phone_number or "").strip()
    if not raw_phone:
        return JsonResponse(
            {"ok": False, "message": "برای این کاربر شماره موبایل ثبت نشده است."},
            status=400,
        )

    mobile = _normalize_mobile_number(raw_phone)
    if not mobile:
        return JsonResponse(
            {"ok": False, "message": "شماره موبایل نامعتبر است."}, status=400
        )

    # تولید کد ۵ رقمی
    otp_code = get_random_string(5, allowed_chars="0123456789")

    # ارسال SMS با استفاده از همان تابع موجود
    sent, provider_message, provider_data = _send_parsgreen_otp(
        mobile, otp_code, request.get_host()
    )

    if not sent:
        return JsonResponse({"ok": False, "message": provider_message}, status=503)

    # ذخیره در سشن
    request.session[LOGIN_OTP_SESSION_KEY] = {
        "national_id": national_id,
        "otp_code": otp_code,
        "expires_at": (
            timezone.now() + timedelta(seconds=LOGIN_OTP_EXPIRE_SECONDS)
        ).isoformat(),
        "attempts": 0,
    }
    request.session.modified = True

    response_data = {"ok": True, "message": "کد تایید ارسال شد."}
    if settings.DEBUG and request.POST.get("debug") == "1":
        response_data["debug"] = {"mobile": mobile, "otp_code": otp_code}
    return JsonResponse(response_data)


def _verify_otp(request, national_id, otp_code):
    """
    بررسی کد تایید OTP برای ورود.
    خروجی: (user_or_None, error_message_or_None)
    """
    if not re.fullmatch(r"\d{10}", national_id):
        return None, "کد ملی باید ۱۰ رقم باشد."
    if not re.fullmatch(r"\d{5}", otp_code):
        return None, "کد تایید باید ۵ رقم باشد."

    state = request.session.get(LOGIN_OTP_SESSION_KEY) or {}
    if not state or state.get("national_id") != national_id:
        return None, "درخواست ورود با کد یکبارمصرف نامعتبر است. لطفاً دوباره تلاش کنید."

    # بررسی انقضا
    expires_at_raw = state.get("expires_at")
    try:
        expires_at = datetime.fromisoformat(expires_at_raw)
        if timezone.is_naive(expires_at):
            expires_at = timezone.make_aware(
                expires_at, timezone.get_current_timezone()
            )
    except (TypeError, ValueError):
        request.session.pop(LOGIN_OTP_SESSION_KEY, None)
        return None, "زمان اعتبار کد نامعتبر است."

    if timezone.now() > expires_at:
        request.session.pop(LOGIN_OTP_SESSION_KEY, None)
        return None, "زمان اعتبار کد به پایان رسیده است. لطفاً دوباره درخواست کنید."

    # بررسی تعداد تلاش
    if otp_code != str(state.get("otp_code") or ""):
        attempts = int(state.get("attempts", 0)) + 1
        state["attempts"] = attempts
        if attempts >= MAX_OTP_ATTEMPTS:
            request.session.pop(LOGIN_OTP_SESSION_KEY, None)
            return (
                None,
                "تعداد تلاش ناموفق بیش از حد مجاز شد. لطفاً دوباره درخواست دهید.",
            )
        request.session[LOGIN_OTP_SESSION_KEY] = state
        request.session.modified = True
        return None, "کد تایید اشتباه است."

    # موفقیت‌آمیز
    request.session.pop(LOGIN_OTP_SESSION_KEY, None)
    employee = Employee.objects.filter(national_id=national_id, is_active=True).first()
    if not employee:
        return None, "کاربر یافت نشد."
    return employee, None


@login_required
def landing_page(request):

    user = request.user

    modules = build_modules_for_user(request)

    context = {
        "modules": modules,
    }

    return render(request, "users/landing.html", context)


@login_required
def build_modules_for_user(request):

    try:
        role_name = request.session["current_role"]
        holding_id = request.session["current_holding_id"]
        factory_id = request.session["current_factory_id"]
        department_id = request.session["current_department_id"]
        subdepartment_id = request.session["current_subdepartment_id"]
        user = request.user
        management_tree = request.session.get("management_tree", [])
        is_committee = request.session["current_is_committee"]
        real_role_name = request.GET.get("current_real_role")
    except Exception as e:
        messages.error(
            request,
            "متاسفانه در سامانه برای شما نقش و قسمت تعریف نشده است ، لطفا با واحد هوش مصنوعی تماس حاصل بفرمایید. 09136304789",
        )
        return logout_view(request)

    management_access = role_name in {
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    }

    user = request.user
    current_host = request.get_host()

    modules = {}

    if user.karimax_permision:

        modules["self"] = {
            "name": "سلف",
            "link": "/self",
            "icon_name": "self.svg",
            "color": "#23359c",
            "coming_soon": False,
            "have_permision": True,
            "micro_modules": {
                "food_reservation": {
                    "name": "رزرو غذا",
                    "link": "users:food_reservation",
                    "icon_name": "self/رزرو غذا.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": True,
                },
                "personal_report": {
                    "name": "گزارش فردی",
                    "link": "users:personal_reports_dashboard",
                    "icon_name": "self/گزاش فردی.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": True,
                    "have_permision": True,
                },
                "health": {
                    "name": "سلامت فردی",
                    "link": "#",
                    "icon_name": "self/سلامت فردی .svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "food_delivery": {
                    "name": "تحویل غذا",
                    "link": "users:food_delivery_page",
                    "icon_name": "self/تحویل غذا.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.food_receiver_role > 0,
                },
                "comments": {
                    "name": "نظر دهی",
                    "link": "#",
                    "icon_name": "self/نظر دهی.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "food_reservation_for_others": {
                    "name": "رزرو غذا برای دیگران",
                    "link": "users:food_reservation_for_others",
                    "icon_name": "self/رزرو غذا برای دیگران.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.can_reserve_for_others > 0,
                },
                "management_food_reservation_view": {
                    "name": "رزرو غذای مدیریتی",
                    "link": "users:management_food_reservation_view",
                    "icon_name": "self/رزرو غذای مدیریتی .svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.can_reserve_management_food,
                },
                "manage_self_menu": {
                    "name": "مدیریت منوی سلف",
                    "link": "users:manage_self_menu",
                    "icon_name": "self/مدیریت منوی سلف.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": role_name == "department_manager"
                    and Department.objects.filter(
                        Q(managers=request.user),
                        is_self=True,
                    ).exists(),
                },
                "restaurant_management_dashboard": {
                    "name": "مدیریت رستوران",
                    "link": "users:restaurant_management_dashboard",
                    "icon_name": "self/مدیریت منوی سلف.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": role_name == "supervisor"
                    and Subdepartment.objects.filter(
                        Q(supervisors=request.user),
                        is_restaurant=True,
                    ).exists(),
                },
                "managements_reports_dashboard": {
                    "name": "گزارش گیری مدیریتی",
                    "link": "users:managements_reports_dashboard",
                    "icon_name": "self/گزارش گیری بدهی سلف.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.reporting_permision == 1,
                },
                "gust_food_reservation_view": {
                    "name": "رزرو غذای میهمان ",
                    "link": "#",
                    "icon_name": "self/رزرو غذای مهمان .svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["participation"] = {
            "name": "مدیریت دانش",
            "link": "/self",
            "icon_name": "mosharekat.svg",
            "color": "#9c3b23",
            "coming_soon": False,
            "have_permision": True,
            "micro_modules": {
                "submit_participation": {
                    "name": "ثبت مشارکت",
                    "link": "users:submit_participation",
                    "icon_name": "add_participation/add.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": True,
                },
                "dashboard": {
                    "name": "مشارکت های من",
                    "link": "users:dashboard",
                    "icon_name": "add_participation/my_particip.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": True,
                },
                "management_dashboard": {
                    "name": "داشبورد مدیریتی",
                    "link": "users:management_dashboard",
                    "icon_name": "add_participation/Vector.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": management_access,
                },
                "participation_reports": {
                    "name": "پنل گزارش گیری",
                    "link": "users:dashboard",
                    "icon_name": "add_participation/report.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "referral": {
                    "name": "ارجاع",
                    "link": "#",
                    "icon_name": "add_participation/refere.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "referrals_inbox": {
                    "name": "ارجاعات دریافتی",
                    "link": "users:referrals_inbox",
                    "icon_name": "add_participation/refere.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["HR"] = {
            "name": "نیروی انسانی",
            "link": "/HR",
            "icon_name": "estekhdam.svg",
            "color": "#79B0D4",
            "coming_soon": False,
            "have_permision": True,
            "micro_modules": {
                "user_management": {
                    "name": "مدیریت پرسنل",
                    "link": "users:user_management",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.manage_sub_employees,
                },
                "import_employees": {
                    "name": "ورود پرسنل (اکسل)",
                    "link": "users:import_employees",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": False,
                    "have_permision": user.manage_sub_employees,
                },
            },
        }

    # poblic modules

    modules["jazb"] = {
        "name": "جذب و استخدام",
        "link": "/self",
        "icon_name": "estekhdam.svg",
        "color": "#9c234b",
        "coming_soon": False,
        "have_permision": True,
        "micro_modules": {
            "jazb1": {
                "name": "داشبورد سامانه جذب و استخدام",
                "link": f"https://jazb.{current_host}/dashboard",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": False,
                "have_permision": True,
            },
            "reserv": {
                "name": "ساخت رزومه جدید",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv1": {
                "name": "رزومه های من",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv2": {
                "name": "پیشنهادات شغلی",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv3": {
                "name": "ایجاد آگهی شغلی",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv4": {
                "name": "مدیریت کاربران",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv5": {
                "name": "شغل های پیشنهاد شده به کاربر",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv6": {
                "name": "مدیریت رزومه ها",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
        },
    }

    modules["quiz"] = {
        "name": "آزمون ها",
        "link": "/self",
        "icon_name": "taghvimjalasat.svg",
        "color": "#239c82",
        "coming_soon": False,
        "have_permision": True,
        "micro_modules": {
            "quizb1": {
                "name": "داشبورد سامانه کوییز",
                "link": f"https://quiz.{current_host}",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": False,
                "have_permision": True,
            },
            "reserv": {
                "name": "آزمون های من",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv1": {
                "name": "مدیریت آزمون ها",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv2": {
                "name": "ساخت آزمون جدید ",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv3": {
                "name": "گزارش گیری",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
            "reserv4": {
                "name": "مدیریت کاربران",
                "link": "#",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": True,
                "have_permision": True,
            },
        },
    }

    modules["Support"] = {
        "name": "پشتیبانی",
        "link": "/self",
        "icon_name": "shekayat.svg",
        "color": "#238a9c",
        "coming_soon": False,
        "have_permision": True,
        "micro_modules": {
            "reserv": {
                "name": "پشتیبانی",
                "link": "users:contact_us",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": False,
                "have_permision": True,
            },
            "reserv1": {
                "name": "تغییر رمز",
                "link": "users:change_password",
                "icon_name": "mosharekat.svg",
                "color": "#8b2650",
                "coming_soon": False,
                "have_permision": True,
            },
        },
    }

    # inprocess modules
    if user.karimax_permision:

        modules["edari"] = {
            "name": "امور اداری",
            "link": "/self",
            "icon_name": "mosharekat.svg",
            "color": "#239c47",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "فیش حقوقی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "مساعده",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "قراردادها",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "نامه های اداری",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv4": {
                    "name": "مقررات سازمانی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv5": {
                    "name": "شرح شغلی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv6": {
                    "name": "سوابق کاری",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv7": {
                    "name": "تردد",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv8": {
                    "name": "اموالی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["trip"] = {
            "name": "سفر",
            "link": "/self",
            "icon_name": "morakhasi.svg",
            "color": "#9c2378",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "درخواست سفر",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "لیست درخواست ها",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "تاییدات",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "تاریخچه تاییدات",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv4": {
                    "name": "راهنمای سفر",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv5": {
                    "name": "دستورالعمل",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv6": {
                    "name": "سوالات متداول",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["amalkard"] = {
            "name": "مدیریت عملکرد",
            "link": "/self",
            "icon_name": "arzyabiamalkard.svg",
            "color": "#909c23",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "مدیریت عملکرد",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["train"] = {
            "name": "آموزش",
            "link": "/self",
            "icon_name": "amoozesh.svg",
            "color": "#9c6c23",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "آموزش",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "آموزش های من",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "گواهی های من",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "دانشنامه دیجیتال",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv4": {
                    "name": "آموزش های بهبودی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv5": {
                    "name": "لیست دوره ها",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv6": {
                    "name": "سوالات متداول",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["welfare_affairs"] = {
            "name": "اموررفاهی",
            "link": "/self",
            "icon_name": "hoghoogh.svg",
            "color": "#0ee2ad",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "سپ کارت",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "ارزاق",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["dept"] = {
            "name": "صتدوق وام",
            "link": "/self",
            "icon_name": "mosharekat.svg",
            "color": "#0b6b28",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "درخواست جدید",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "درخواست های من",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "مدیریت درخواست ها",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "گزارش گیری",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["charity"] = {
            "name": "نیکوکاری",
            "link": "/self",
            "icon_name": "mosharekat.svg",
            "color": "#0c1650",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "خیریه نذر اشتغال",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "نذورات",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "قربانی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "گزارش گیری",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["insurance"] = {
            "name": "بیمه",
            "link": "/self",
            "icon_name": "asnad.svg",
            "color": "#23359c",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "بیمه تکمیلی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "بیماران خاص",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv2": {
                    "name": "سامانه نوبت دهی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv3": {
                    "name": "گزارش گیری",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["exercise"] = {
            "name": "تربیت بدنی",
            "link": "/self",
            "icon_name": "mosharekat.svg",
            "color": "#5f72e0",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "مسابقات ورزشی",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "افتخارات",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

        modules["clouds_services"] = {
            "name": "سامانه های ابری",
            "link": "/clouds",
            "icon_name": "mosharekat.svg",
            "color": "#5f6836",
            "coming_soon": True,
            "have_permision": True,
            "micro_modules": {
                "reserv": {
                    "name": "فضای ابری",
                    "link": "https://cloud.karimax.ir/",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
                "reserv1": {
                    "name": "سامانه میت",
                    "link": "#",
                    "icon_name": "mosharekat.svg",
                    "color": "#8b2650",
                    "coming_soon": True,
                    "have_permision": True,
                },
            },
        }

    return modules


def contact_us(request):

    context = {
        "contact_phone_number": settings.CONTACT_PHONE_NUMBER,
    }

    return render(request, "users/contact_us.html", context)


def logout_view(request):
    """خروج کاربر از سیستم و پاک کردن تاریخچه چت از سشن."""

    request.session.flush()

    if "chat_history" in request.session:
        del request.session["chat_history"]

    logout(request)

    return redirect("users:login")


@staff_member_required  # فقط ادمین‌ها (is_staff) دسترسی داشته باشند
def force_logout_all_users(request, only_current_user=False):
    # تنظیم فلگ login_required برای همه کاربران فعال
    updated_count = Employee.objects.filter(is_active=True).update(login_required=True)

    # پیام موفقیت
    messages.success(
        request,
        f"{updated_count} کاربر برای خروج اجباری در درخواست بعدی علامت‌گذاری شدند.",
    )

    Session.objects.all().delete()

    return redirect("users:login")


# 1. تابع جدید ارسال پیامک عمومی (هر متنی)
def _send_sms(mobile, message, sms_number=None):
    """
    ارسال پیامک متنی به یک شماره موبایل با استفاده از API پارس‌گرین.
    پارامترها:
        mobile: شماره موبایل نرمال‌شده (مثلاً 09123456789)
        message: متن پیامک
        sms_number: شماره خط ارسال‌کننده (اختیاری)
    خروجی:
        (موفقیت, پیام, داده‌ی پاسخ)
    """
    api_key = (getattr(settings, "PARSGREEN_SMS_API_KEY", "") or "").strip()
    if not api_key:
        api_key = PARSGREEN_DEFAULT_API_KEY

    if sms_number is None:
        sms_number = (
            getattr(settings, "PARSGREEN_SMS_NUMBER", "")
            or getattr(settings, "PARSGREEN_SMS_SENDER", "")
            or ""
        )
    sms_number = str(sms_number).strip()

    if not sms_number:
        return False, "شماره خط پیامکی تنظیم نشده است.", {}

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"basic apikey:{api_key}",
    }

    payload = {
        "SmsBody": message,
        "Mobiles": [mobile],
        "SmsNumber": sms_number,
    }

    try:
        response = requests.post(
            PARSGREEN_SEND_SMS_URL,
            headers=headers,
            json=payload,
            timeout=15,
        )
    except requests.RequestException as exc:
        return False, "خطا در ارتباط با سامانه پیامکی.", {"exception": str(exc)}

    try:
        data = response.json()
    except ValueError:
        data = {}

    # بررسی موفقیت بر اساس مستندات پارس‌گرین
    success = (
        response.status_code < 400
        and bool(data.get("R_Success"))
        and int(data.get("R_Code", 0)) == 0
    )
    if success:
        return True, "پیامک با موفقیت ارسال شد.", data
    else:
        return False, data.get("R_Message") or "ارسال پیامک ناموفق بود.", data


def _normalize_mobile_number(raw_phone):
    if not raw_phone:
        return None

    phone = str(raw_phone).strip().replace(" ", "").replace("-", "")

    if phone.startswith("+98"):
        phone = "0" + phone[3:]
    elif phone.startswith("0098"):
        phone = "0" + phone[4:]
    elif phone.startswith("98"):
        phone = "0" + phone[2:]

    if not phone.isdigit():
        return None

    if len(phone) != 11 or not phone.startswith("09"):
        return None

    return phone


def _build_password_reset_sms_body(otp_code, origin_host):
    host = (origin_host).strip()
    host = host.split(":")[0].lower()
    if not host:
        host = "www.karimax.ir"

    return "\n".join(
        [
            f"Code: {otp_code}",
            f"رمز یک بار مصرف سامانه karimax.ir",
            f"@{host} #{otp_code}",
        ]
    )


def _send_parsgreen_otp(mobile, otp_code, origin_host="karimax.ir"):
    api_key = (getattr(settings, "PARSGREEN_SMS_API_KEY", "") or "").strip()
    if not api_key:
        api_key = PARSGREEN_DEFAULT_API_KEY

    sms_number = (
        getattr(settings, "PARSGREEN_SMS_NUMBER", "")
        or getattr(settings, "PARSGREEN_SMS_SENDER", "")
        or ""
    )

    # sms_number = "7007022"
    sms_number = "10008615"
    # sms_number = "10004004040"

    print("USING CUSTOM SMS:", bool(sms_number))

    sms_number = str(sms_number).strip()

    print("USING CUSTOM SMS:", bool(sms_number))

    headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": f"basic apikey:{api_key}",
    }
    custom_sms_error = None

    if sms_number:
        custom_payload = {
            "SmsBody": _build_password_reset_sms_body(otp_code, origin_host),
            "Mobiles": [mobile],
            "SmsNumber": sms_number,
        }

        try:
            response = requests.post(
                PARSGREEN_SEND_SMS_URL,
                headers=headers,
                json=custom_payload,
                timeout=15,
            )
        except requests.RequestException as exc:
            custom_sms_error = {"exception": str(exc)}
        else:
            try:
                data = response.json()
            except ValueError:
                data = {}

            success_count_raw = data.get("SuccessCount", None)
            try:
                success_count_ok = (
                    success_count_raw is None or int(success_count_raw) >= 1
                )
            except (TypeError, ValueError):
                success_count_ok = True

            custom_success = (
                response.status_code < 400
                and bool(data.get("R_Success"))
                and int(data.get("R_Code", 0)) == 0
                and success_count_ok
            )
            if custom_success:
                return True, "کد تایید ارسال شد.", data

            custom_sms_error = data or {"status_code": response.status_code}

    otp_payload = {
        "Mobile": mobile,
        "SmsCode": otp_code,
        "AddName": True,
    }
    try:
        otp_response = requests.post(
            PARSGREEN_SEND_OTP_URL,
            headers=headers,
            json=otp_payload,
            timeout=15,
        )
    except requests.RequestException as exc:
        data = {"exception": str(exc)}
        if custom_sms_error:
            data["custom_sms_error"] = custom_sms_error
        return False, "خطا در ارتباط با سامانه پیامکی.", data

    try:
        otp_data = otp_response.json()
    except ValueError:
        otp_data = {}

    otp_success = (
        otp_response.status_code < 400
        and bool(otp_data.get("R_Success"))
        and int(otp_data.get("R_Code", 0)) == 0
    )
    if otp_success:
        if custom_sms_error:
            otp_data["fallback_used"] = True
        return True, "کد تایید ارسال شد.", otp_data

    if custom_sms_error:
        otp_data["custom_sms_error"] = custom_sms_error
    return False, otp_data.get("R_Message") or "ارسال OTP ناموفق بود.", otp_data


def forgot_password_stub_view(request):
    if request.method != "POST":
        return JsonResponse({"ok": False, "message": "متد نامعتبر است."}, status=405)

    national_id = (request.POST.get("national_id") or "").strip()
    if not re.fullmatch(r"\d{10}", national_id):
        return JsonResponse(
            {"ok": False, "message": "کد ملی باید ۱۰ رقم باشد."},
            status=400,
        )

    employee = Employee.objects.filter(national_id=national_id, is_active=True).first()
    if not employee:
        return JsonResponse(
            {"ok": False, "message": "کاربری با این کد ملی یافت نشد."},
            status=404,
        )

    raw_phone = (employee.phone_number or "").strip()
    if not raw_phone:
        return JsonResponse(
            {"ok": False, "message": "برای این کاربر شماره موبایل ثبت نشده است."},
            status=400,
        )

    mobile = _normalize_mobile_number(raw_phone)
    if not mobile:
        return JsonResponse(
            {
                "ok": False,
                "message": "شماره موبایل نامعتبر است. باید 11 رقمی و با 09 شروع شود.",
            },
            status=400,
        )

    otp_code = get_random_string(5, allowed_chars="0123456789")
    # otp_code = "12345"
    sent, provider_message, provider_data = _send_parsgreen_otp(
        mobile, otp_code, request.get_host()
    )

    print(
        "forgot_password_stub_view:",
        {
            "national_id": national_id,
            "raw_phone": raw_phone,
            "normalized_phone": mobile,
            "otp_code": otp_code,
            "sent": sent,
            "provider_message": provider_message,
            "provider_data": provider_data,
        },
    )

    if not sent:
        status_code = 503 if "exception" in provider_data else 400
        return JsonResponse(
            {
                "ok": False,
                "message": provider_message,
                "debug": provider_data if settings.DEBUG else None,
            },
            status=status_code,
        )

    request.session[FORGOT_PASSWORD_SESSION_KEY] = {
        "national_id": national_id,
        "otp_code": otp_code,
        "expires_at": (
            timezone.now() + timedelta(seconds=FORGOT_PASSWORD_OTP_EXPIRE_SECONDS)
        ).isoformat(),
        "attempts": 0,
    }
    request.session.pop(FORGOT_PASSWORD_VERIFIED_SESSION_KEY, None)
    request.session.modified = True

    response_data = {
        "ok": True,
        "message": "کد تایید ارسال شد.",
    }
    if settings.DEBUG and request.POST.get("debug") == "1":
        response_data["debug"] = {
            "normalized_phone": mobile,
            "otp_code": otp_code,
            "provider_data": provider_data,
        }

    return JsonResponse(response_data)


def forgot_password_verify_stub_view(request):
    if request.method != "POST":
        return JsonResponse({"ok": False, "message": "متد نامعتبر است."}, status=405)

    national_id = (request.POST.get("national_id") or "").strip()
    otp_code = (request.POST.get("otp_code") or "").strip()

    if not re.fullmatch(r"\d{10}", national_id):
        return JsonResponse(
            {"ok": False, "message": "کد ملی باید ۱۰ رقم باشد."},
            status=400,
        )

    if not re.fullmatch(r"\d{5}", otp_code):
        return JsonResponse(
            {"ok": False, "message": "کد تایید باید ۵ رقم باشد."},
            status=400,
        )

    state = request.session.get(FORGOT_PASSWORD_SESSION_KEY) or {}
    if not state or state.get("national_id") != national_id:
        return JsonResponse(
            {"ok": False, "message": "درخواست بازیابی معتبر نیست. دوباره تلاش کنید."},
            status=400,
        )

    expires_at_raw = state.get("expires_at")
    try:
        expires_at = datetime.fromisoformat(expires_at_raw)
        if timezone.is_naive(expires_at):
            expires_at = timezone.make_aware(
                expires_at, timezone.get_current_timezone()
            )
    except (TypeError, ValueError):
        request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "زمان اعتبار کد نامعتبر است."},
            status=400,
        )

    if timezone.now() > expires_at:
        request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "زمان اعتبار کد به پایان رسیده است."},
            status=400,
        )

    if otp_code != str(state.get("otp_code") or ""):
        attempts = int(state.get("attempts", 0)) + 1
        state["attempts"] = attempts

        if attempts >= 5:
            request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
            return JsonResponse(
                {"ok": False, "message": "تعداد تلاش ناموفق بیش از حد مجاز شد."},
                status=400,
            )

        request.session[FORGOT_PASSWORD_SESSION_KEY] = state
        request.session.modified = True
        return JsonResponse(
            {"ok": False, "message": "کد تایید اشتباه است."},
            status=400,
        )

    employee = Employee.objects.filter(national_id=national_id, is_active=True).first()
    if not employee:
        request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "کاربر یافت نشد."},
            status=404,
        )

    request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
    request.session[FORGOT_PASSWORD_VERIFIED_SESSION_KEY] = {
        "national_id": national_id,
        "expires_at": (
            timezone.now() + timedelta(seconds=FORGOT_PASSWORD_VERIFIED_EXPIRE_SECONDS)
        ).isoformat(),
    }
    request.session.modified = True

    return JsonResponse(
        {
            "ok": True,
            "message": "کد تایید شد. رمز عبور جدید را وارد کنید.",
        }
    )


def forgot_password_set_password_stub_view(request):
    if request.method != "POST":
        return JsonResponse({"ok": False, "message": "متد نامعتبر است."}, status=405)

    national_id = (request.POST.get("national_id") or "").strip()
    new_password = (request.POST.get("new_password") or "").strip()
    confirm_password = (request.POST.get("confirm_password") or "").strip()

    if not re.fullmatch(r"\d{10}", national_id):
        return JsonResponse(
            {"ok": False, "message": "کد ملی باید ۱۰ رقم باشد."},
            status=400,
        )

    if not new_password:
        return JsonResponse(
            {"ok": False, "message": "رمز عبور جدید را وارد کنید."},
            status=400,
        )

    if new_password != confirm_password:
        return JsonResponse(
            {"ok": False, "message": "رمز عبور و تکرار آن یکسان نیست."},
            status=400,
        )

    verified_state = request.session.get(FORGOT_PASSWORD_VERIFIED_SESSION_KEY) or {}
    if not verified_state or verified_state.get("national_id") != national_id:
        return JsonResponse(
            {"ok": False, "message": "ابتدا کد تایید را به‌درستی وارد کنید."},
            status=400,
        )

    expires_at_raw = verified_state.get("expires_at")
    try:
        expires_at = datetime.fromisoformat(expires_at_raw)
        if timezone.is_naive(expires_at):
            expires_at = timezone.make_aware(
                expires_at, timezone.get_current_timezone()
            )
    except (TypeError, ValueError):
        request.session.pop(FORGOT_PASSWORD_VERIFIED_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "درخواست بازیابی نامعتبر است."},
            status=400,
        )

    if timezone.now() > expires_at:
        request.session.pop(FORGOT_PASSWORD_VERIFIED_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "زمان ثبت رمز جدید به پایان رسیده است."},
            status=400,
        )

    employee = Employee.objects.filter(national_id=national_id, is_active=True).first()
    if not employee:
        request.session.pop(FORGOT_PASSWORD_VERIFIED_SESSION_KEY, None)
        return JsonResponse(
            {"ok": False, "message": "کاربر یافت نشد."},
            status=404,
        )

    try:
        validate_password(new_password, user=employee)
    except ValidationError as exc:
        return JsonResponse(
            {"ok": False, "message": " ".join(exc.messages)},
            status=400,
        )

    employee.set_password(new_password)
    employee.is_first_login = False
    employee.save(update_fields=["password", "is_first_login"])

    request.session.pop(FORGOT_PASSWORD_VERIFIED_SESSION_KEY, None)
    request.session.pop(FORGOT_PASSWORD_SESSION_KEY, None)
    request.session.modified = True

    return JsonResponse(
        {
            "ok": True,
            "message": "رمز عبور با موفقیت تغییر کرد. با رمز جدید وارد شوید.",
            "redirect_url": reverse("users:login"),
            "national_id": national_id,
        }
    )


# 🌟 جدید: تابع کمکی برای ساخت درخت نقش‌های مدیریتی
def build_management_tree(user):
    """
    درخت نقش‌های مدیریتی کاربر را با جزئیات هلدینگ، کارخانه، بخش و زیربخش می‌سازد.
    فقط سطوحی که کاربر در آن‌ها نقش مدیریتی دارد (manager/supervisor) را شامل می‌شود.
    ساختار: لیست هلدینگ‌ها، هر کدام با factories, departments, subdepartments.
    هر سطح دارای 'role' اگر کاربر مدیر/سرپرست آن سطح باشد.
    """

    # پیدا کردن تمام هلدینگ‌های مرتبط (جایی که کاربر در آن یا زیرمجموعه نقش دارد)

    # MARK: committee todo
    related_holdings = (
        Holding.objects.filter(
            Q(managers=user)
            | Q(factories__managers=user)
            # | Q(factories__departments__manager=user)
            | Q(factories__departments__managers=user)
            | Q(factories__departments__manager_2=user)
            | Q(factories__departments__manager_3=user)
            # | Q(factories__departments__subdepartments__supervisor=user)
            | Q(factories__departments__subdepartments__supervisors=user)
            | Q(factories__departments__subdepartments__assigned_employees=user)
        )
        .distinct()
        .order_by("name")
    )
    # MARK: committee todo end

    management_tree_1 = []

    for holding in related_holdings:
        holding_dict = {
            "id": holding.id,
            "name": holding.name,
            "role": (
                "holding_manager"
                if holding.managers.filter(id=user.id).exists()
                else None
            ),
            "factories": [],
        }

        # MARK: committee todo

        # کارخانه‌های مرتبط در این هلدینگ
        related_factories = (
            Factory.objects.filter(holding=holding)
            .filter(
                Q(managers=user)
                # | Q(departments__manager=user)
                | Q(departments__managers=user)
                | Q(departments__manager_2=user)
                | Q(departments__manager_3=user)
                # | Q(departments__subdepartments__supervisor=user)
                | Q(departments__subdepartments__supervisors=user)
                | Q(departments__subdepartments__assigned_employees=user)
            )
            .distinct()
            .order_by("name")
        )
        # MARK: committee todo end

        for factory in related_factories:
            factory_dict = {
                "id": factory.id,
                "name": factory.name,
                "role": (
                    "factory_manager"
                    if factory.managers.filter(id=user.id).exists()
                    else None
                ),
                "departments": [],
            }

            # MARK: committee todo

            # بخش‌های مرتبط در این کارخانه
            related_departments = (
                Department.objects.filter(factory=factory)
                .filter(
                    # Q(manager=user) |
                    Q(managers=user)
                    | Q(manager_2=user)
                    | Q(manager_3=user)
                    # | Q(subdepartments__supervisor=user)
                    | Q(subdepartments__supervisors=user)
                    | Q(subdepartments__assigned_employees=user)
                )
                .distinct()
                .order_by("name")
            )
            # MARK: committee todo end

            for department in related_departments:

                # MARK: committee todo
                department_dict = {
                    "id": department.id,
                    "name": department.name,
                    "role": (
                        "department_manager"  # department.manager == user or
                        if department.managers.filter(id=user.id).exists()
                        or department.manager_2 == user
                        or department.manager_3 == user
                        else None
                    ),
                    "roles": [],
                    "subdepartments": [],
                }
                roles = []

                if (
                    # department.manager == user or
                    department.managers.filter(id=user.id).exists()
                ):
                    roles.append("department_manager")
                if department.is_committee:
                    if department.manager_2 == user:
                        roles.append("department_manager_2")
                    if department.manager_3 == user:
                        roles.append("department_manager_3")
                department_dict["roles"] = roles if roles else None
                # MARK: committee todo end

                # زیربخش‌های مرتبط در این بخش
                related_subdepartments = (
                    Subdepartment.objects.filter(department=department)
                    .filter(
                        # Q(supervisor=user) |
                        Q(supervisors=user)
                        | Q(assigned_employees=user)
                    )
                    .distinct()
                    .order_by("name")
                )

                for subdepartment in related_subdepartments:
                    roles = []
                    if (
                        # subdepartment.supervisor == user or
                        subdepartment.supervisors.filter(id=user.id).exists()
                    ):
                        roles.append("supervisor")
                    if user in subdepartment.assigned_employees.all():
                        roles.append("employee")

                    subdepartment_dict = {
                        "id": subdepartment.id,
                        "name": subdepartment.name,
                        "roles": roles,
                    }
                    department_dict["subdepartments"].append(subdepartment_dict)

                factory_dict["departments"].append(department_dict)

            holding_dict["factories"].append(factory_dict)

        management_tree_1.append(holding_dict)

    is_super_admin = user.roles.filter(name="super_admin").exists()

    if is_super_admin:
        management_tree = {
            "id": None,
            "name": "مدیر کل سیستم",
            "role": "super_admin",
            "holdings": management_tree_1,
        }
    else:
        management_tree = {
            "id": None,
            "name": "مدیر کل سیستم",
            "role": "None",
            "holdings": management_tree_1,
        }

    # print([management_tree])
    return [management_tree]

    # return management_tree


# 🌟 جدید: view برای سوییچ نقش با جزئیات context (هلدینگ، کارخانه، بخش، زیربخش)
def switch_role(request):
    role_name = request.GET.get("role")
    holding_id = request.GET.get("holding_id")
    factory_id = request.GET.get("factory_id")
    department_id = request.GET.get("department_id")
    subdepartment_id = request.GET.get("subdepartment_id")
    real_role = request.GET.get("real_role")

    # تبدیل به None اگر 'None' بود
    holding_id = None if holding_id == "None" else holding_id
    factory_id = None if factory_id == "None" else factory_id
    department_id = None if department_id == "None" else department_id
    subdepartment_id = None if subdepartment_id == "None" else subdepartment_id
    is_committee = False

    user = request.user

    # اعتبار سنجی نقش
    if role_name not in [r.name for r in user.roles.all()]:
        messages.error(request, "شما این نقش را ندارید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    # اعتبار سنجی مکان‌ها بر اساس نقش
    if role_name == "super_admin":
        if holding_id or factory_id or department_id or subdepartment_id:
            messages.error(request, "برای super_admin هیچ مکانی نباید مشخص شود.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
    elif role_name == "holding_manager":
        if not holding_id:
            messages.error(request, "holding_id الزامی است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")

        holding = get_object_or_404(Holding, id=holding_id, managers=user)
        if factory_id or department_id or subdepartment_id:
            messages.error(request, "برای holding_manager فقط holding_id معتبر است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
    elif role_name == "factory_manager":
        if not factory_id:
            messages.error(request, "factory_id الزامی است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
        factory = get_object_or_404(Factory, id=factory_id, managers=user)
        holding_id = factory.holding.id if factory.holding else None
        is_committee = factory.is_committee if factory.is_committee else False
        if department_id or subdepartment_id:
            messages.error(
                request,
                "برای factory_manager فقط factory_id (و holding_id اختیاری) معتبر است.",
            )
            # return redirect("users:dashboard")
            return redirect("users:landing")
    elif role_name == "department_manager":

        if not department_id:
            messages.error(request, "department_id الزامی است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")

        if real_role == "department_manager":
            # department = get_object_or_404(Department, id=department_id, manager=user)
            department = get_object_or_404(
                Department,
                # Q(manager=user) |
                Q(managers=user),
                id=department_id,
            )

        # MARK: committee todo
        elif real_role == "department_manager_2":
            department = get_object_or_404(Department, id=department_id, manager_2=user)
        elif real_role == "department_manager_3":
            department = get_object_or_404(Department, id=department_id, manager_3=user)
        # MARK: committee todo end

        factory_id = department.factory.id
        holding_id = (
            department.factory.holding.id if department.factory.holding else None
        )
        is_committee = department.is_committee if department.is_committee else False
        if subdepartment_id:
            messages.error(
                request,
                "برای department_manager فقط department_id (و بالادستی‌ها) معتبر است.",
            )
            # return redirect("users:dashboard")
            return redirect("users:landing")
    elif role_name == "supervisor":
        if not subdepartment_id:
            messages.error(request, "subdepartment_id الزامی است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")

        subdepartment = get_object_or_404(
            Subdepartment,  # Q(supervisor=user) |
            Q(supervisors=user),
            id=subdepartment_id,
        )

        department_id = subdepartment.department.id
        factory_id = subdepartment.department.factory.id
        holding_id = (
            subdepartment.department.factory.holding.id
            if subdepartment.department.factory.holding
            else None
        )
        is_committee = (
            subdepartment.is_committee if subdepartment.is_committee else False
        )
    elif role_name == "employee":
        if not subdepartment_id:
            messages.error(request, "subdepartment_id الزامی است.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
        # اعتبار سنجی که کاربر به این subdepartment تخصیص یافته باشد
        if not user.assigned_subdepartments.filter(id=subdepartment_id).exists():
            messages.error(request, "شما به این زیربخش تخصیص نیافته‌اید.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
        subdepartment = get_object_or_404(Subdepartment, id=subdepartment_id)
        department_id = subdepartment.department.id
        factory_id = subdepartment.department.factory.id
        holding_id = (
            subdepartment.department.factory.holding.id
            if subdepartment.department.factory.holding
            else None
        )

    # ذخیره در سشن
    request.session["current_role"] = role_name
    request.session["current_holding_id"] = holding_id
    request.session["current_factory_id"] = factory_id
    request.session["current_department_id"] = department_id
    request.session["current_subdepartment_id"] = subdepartment_id
    request.session["current_is_committee"] = is_committee if is_committee else False
    request.session["current_real_role"] = real_role if real_role else None

    # messages.success(request, f"نقش به {role_name} تغییر یافت.")

    if role_name in {
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    }:
        # messages.success(
        #     request,
        #     # "جهت ارتقای سازمان دانش‌محور، تجربیات ارزش‌آفرین خود را هفتگی در سیستم مقدم من ثبت کنید (حداقل یک دانش). گزارش‌گیری ماهانه انجام می‌شود.",
        # )
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر هفته ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    elif role_name == "supervisor":
        # messages.success(
        #     request,
        #     # "سرپرستان و کارشناسان محترم، آموزه‌ها و تجربیات شغلی مفید خود را هفتگی در مقدم من ثبت نمایید (حداقل یک دانش در هفته). گزارش‌گیری ماهانه.",
        # )
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر هفته ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    elif role_name == "employee":
        # messages.success(
        #     request,
        #     # "اپراتورها و کارگران عزیز، تجربیات کاری ارزشمند خود را ماهیانه در سیستم مقدم من ثبت کنید (حداقل یک دانش). گزارش‌گیری ماهانه انجام می‌شود.",
        # )
        msg = """آموزه‌ها و تجربیات شغلی ارزشمند خود را در این سامانه ثبت و جایزه دریافت نمایید.
            «انتظار می‌رود حداقل یک مورد دانش جدید در هر ماه ثبت گردد»
            گزارش‌گیری از دانش‌های ثبت‌شده به‌صورت ماهانه انجام خواهد شد"""
        messages.success(request, msg)

    # return redirect("users:dashboard")
    return redirect("users:landing")


@login_required
def dashboard(request):
    # response = HttpResponse("کش مرورگر با موفقیت پاک شد")
    # response['Clear-Site-Data'] = '"cache"'
    # response['Cache-Control'] = 'no-cache, no-store, must-revalidate, max-age=0'
    # response['Pragma'] = 'no-cache'
    # response['Expires'] = '0'

    # برای دیباگ: هدر رو توی خروجی سرور چاپ کن
    # print(f"DEBUG: Header set to {response['Clear-Site-Data']}")
    # print("okkkkk")

    if request.method == "GET" and request.GET.get("action") == "change":
        add_managers(request)

    try:
        role_name = request.session["current_role"]
        holding_id = request.session["current_holding_id"]
        factory_id = request.session["current_factory_id"]
        department_id = request.session["current_department_id"]
        subdepartment_id = request.session["current_subdepartment_id"]
        user = request.user
        management_tree = request.session.get("management_tree", [])
        is_committee = request.session["current_is_committee"]
        real_role_name = request.GET.get("current_real_role")
    except Exception as e:
        messages.error(
            request,
            "متاسفانه در سامانه برای شما نقش و قسمت تعریف نشده است ، لطفا با واحد هوش مصنوعی تماس حاصل بفرمایید. 09136304789",
        )
        return logout_view(request)
        # return render(request,"users:logout_view")
        # return redirect("users:logout_view")

    current_role = None
    current_role_name = request.session.get("current_role")

    if current_role_name:
        current_role = request.user.roles.filter(name=current_role_name).first()

    if True:
        msg = ""  # متن پیام
        # اضافه کردن extra_tags='banner' برای تشخیص در قالب
        messages.success(request, msg, extra_tags="banner")

    # کاربر فعلی که از نوع Employee هست

    # all_participations = Participation.objects.filter(user=user).order_by('-created_at')
    # all_participations = Participation.objects.filter(user=request.user).order_by('-created_at')
    all_participations = Participation.objects.filter(
        user=request.user,
        role_name=role_name,
        holding_id=holding_id,
        factory_id=factory_id,
        department_id=department_id,
        subdepartment_id=subdepartment_id,
    ).order_by("-created_at")

    participations = all_participations

    selected_status = request.GET.get("status", "").strip() or None
    selected_item_type = request.GET.get("item_type", "").strip() or None
    selected_is_committee = request.GET.get("is_committee", "").strip() or None

    if selected_status:
        participations = participations.filter(status=selected_status)
    if selected_item_type:
        participations = participations.filter(item_type=selected_item_type)
    if selected_is_committee:
        participations = participations.filter(is_committee=selected_is_committee)

    all_participations = participations

    total_count = all_participations.count()  # شمارش کل QuerySet اصلی

    # 🌟 جدید: محاسبات مشارکت امروز و هزینه‌ها
    tehran_aware_datetime = timezone.localtime(timezone.now())
    today = tehran_aware_datetime.date()
    start_of_day = timezone.make_aware(datetime.combine(today, time.min))
    end_of_day = timezone.make_aware(datetime.combine(today, time.max))
    # تعداد مشارکت های امروز

    today_participations = all_participations.filter(
        created_at__gte=start_of_day, created_at__lte=end_of_day
    )

    today_count = today_participations.count()
    # ۱. میزان اضافه کاری مشارکت کل
    total_overtime_cost = total_count * BASE_COST_PER_PARTICIPATION
    # ۳. میزان اضافه کاری مشارکت امروز
    today_overtime_cost = today_count * BASE_COST_PER_PARTICIPATION

    participation_counts = {
        item_type[0]: all_participations.filter(item_type=item_type[0]).count()
        for item_type in Participation.ITEM_TYPES
    }

    # اینجا خطاهای قبلی رفع شده‌اند:
    audio_count = all_participations.filter(is_audio=True).count()
    # other_count = all_participations.filter(is_audio=False).count()

    other_count = all_participations.filter(
        Q(is_audio=False) & ~Q(attachment__isnull=True) & ~Q(attachment="")
    ).count()

    participation_display = [
        {
            "display": label,
            "count": participation_counts.get(key, 0),
            "audio_count": all_participations.filter(
                item_type=key, is_audio=True
            ).count(),
        }
        for key, label in Participation.ITEM_TYPES
    ]

    if request.method == "POST" and request.POST.get("action") == "export_excel":
        data_columns = [
            ("عنوان مشارکت", [p.title or "" for p in all_participations]),
            ("نوع مشارکت", [p.get_item_type_display() for p in all_participations]),
            (
                "تاریخ ثبت",
                [p.created_at for p in all_participations],
            ),  # خود تاریخ → تابع تبدیل می‌کنه
            ("وضعیت", [p.get_status_display() for p in all_participations]),
        ]

        return export_to_excel(
            columns=data_columns,
            filename=f"گزارش_مشارکت‌ها_{jdatetime.datetime.now().strftime('%Y%m%d')}",
            report_title="گزارش جامع مشارکت‌های سیستم",
        )

    participations = all_participations[
        :PARTICIPATIONS_PER_LOAD
    ]  # این یک لیست است (فقط 50 تای اول)
    remaining_count = total_count - len(participations)

    # if not all_participations.exists():
    #     messages.info(request, "شما هنوز هیچ مشارکتی ثبت نکرده‌اید.")

    chart_data = (
        json.dumps(list(participation_counts.values()))
        if participation_counts
        else json.dumps([0, 0, 0, 0, 0])
    )

    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]
    has_management_access = role_name in management_roles

    can_access_evaluation_panel = role_name in ["super_admin", "department_manager"]

    food_receiver_role = user.food_receiver_role

    can_manage_bimeh = role_name in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    ]

    factory_bimeh = user.factory_bimeh
    holding_bimeh = user.holding_bimeh

    can_manage_bimeh = factory_bimeh or holding_bimeh

    can_reserve_for_others = user.can_reserve_for_others > 0

    personnel_management_access = user.manage_sub_employees

    # if request.method == "GET" and request.GET.get("action") == "update_food_prices":
    #     result = update_food_reservation_prices()
    #     print(f"result = {result}")

    can_report = user.reporting_permision != 0

    can_reserve_management_food = user.can_reserve_management_food

    return render(
        request,
        "users/dashboard.html",
        {
            "participations": participations,
            "remaining_count": remaining_count,
            "has_more": remaining_count > 0,
            "user": user,
            "participation_display": participation_display,
            "audio_count": audio_count,
            "other_count": other_count,
            "chart_data": chart_data,
            "current_role": current_role,
            "current_role_name": current_role_name,
            "can_access_evaluation_panel": can_access_evaluation_panel,
            "base_cost": BASE_COST_PER_PARTICIPATION,
            "total_overtime_cost": total_overtime_cost,
            "today_count": today_count,
            "today_overtime_cost": today_overtime_cost,
            "total_count": total_count,
            "participation_status_choices": Participation.STATUS_CHOICES,
            "participation_item_type_choices": Participation.ITEM_TYPES,
            "selected_status": selected_status,
            "selected_item_type": selected_item_type,
            "food_receiver_role": food_receiver_role,
            "can_manage_bimeh": can_manage_bimeh,
            "factory_bimeh": factory_bimeh,
            "holding_bimeh": holding_bimeh,
            "can_reserve_for_others": can_reserve_for_others,
            "personnel_management_access": personnel_management_access,
            "can_report": can_report,
            "can_reserve_management_food": can_reserve_management_food,
            "contact_phone_number": settings.CONTACT_PHONE_NUMBER,
        },
    )


@transaction.atomic
def update_food_reservation_prices():
    """
    به‌روزرسانی قیمت رزروهای غذا از تاریخ ۲۰۲۶-۰۴-۲۱ به بعد
    """
    target_date = date(2026, 4, 21)

    # دریافت تمام رزروهای بعد از تاریخ مشخص شده
    reservations = FoodReservation.objects.filter(
        reservation_date__gte=target_date, is_canceled=False  # فقط رزروهای لغو نشده
    ).select_related("menu_item__food")

    # print(f"reservations : {reservations}")

    # print(f"target_date : {target_date}")

    updated_count = 0

    for reservation in reservations:
        food = reservation.menu_item.food
        print(f"food : {food}")

        # به‌روزرسانی قیمت‌ها از مدل FoodItem
        reservation.factory_price = food.factory_price
        reservation.free_price = food.free_price
        reservation.guest_price = food.guest_price
        reservation.save()

        # محاسبه مجدد قیمت کل
        reservation.total_price = (
            reservation.factory_quantity * food.factory_price
            + reservation.free_quantity * food.free_price
            + reservation.guest_quantity * food.guest_price
        )

        reservation.save()

        # reservation.save(update_fields=[
        #     'factory_price', 'free_price', 'guest_price', 'total_price'
        # ])
        updated_count += 1

    # # اجرای تابع
    # updated = update_food_reservation_prices()
    # print(f"✅ {updated} رزرو با موفقیت به‌روزرسانی شد.")

    return updated_count


@login_required
def notification_create(request):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    user = request.user

    # فقط کاربران مدیریتی اجازه دارند اعلان بسازند
    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]
    current_role = request.session.get("current_role")

    if current_role not in management_roles:
        messages.error(request, "شما اجازه ایجاد اعلان ندارید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    if request.method == "POST":

        title = request.POST.get("title")
        description = request.POST.get("description")
        expires_at_str = request.POST.get("expires_at")
        target_holdings_ids = request.POST.getlist("target_holdings")
        target_factories_ids = request.POST.getlist("target_factories")
        target_departments_ids = request.POST.getlist("target_departments")
        target_subdepartments_ids = request.POST.getlist("target_subdepartments")
        employee_subdepartments_ids = request.POST.getlist("employee_subdepartments")

        expires_at = None
        if expires_at_str:
            try:
                # فرمت ورودی: 1404/09/25
                jy, jm, jd = map(int, expires_at_str.split("/"))
                gregorian_date = jdatetime.date(jy, jm, jd).togregorian()
                expires_at = datetime.combine(
                    gregorian_date, datetime.min.time()
                )  # ساعت 00:00
                expires_at = timezone.make_aware(
                    expires_at
                )  # اگر تنظیمات USE_TZ=True داری
            except Exception as e:
                messages.error(request, "فرمت تاریخ انقضا نامعتبر است.")
                return redirect("users:notification_create")

        notification = Notification.objects.create(
            title=title,
            description=description,
            created_by=request.user,  # مهم: کاربر فعلی که اعلان را می‌سازد
            expires_at=expires_at,
            is_active=True,  # می‌تونی دستی هم تنظیم کنی
        )

        if target_holdings_ids:
            notification.target_holdings.set(target_holdings_ids)
        if target_factories_ids:
            notification.target_factories.set(target_factories_ids)
        if target_departments_ids:
            notification.target_departments.set(target_departments_ids)
        if target_subdepartments_ids:
            notification.target_subdepartments.set(target_subdepartments_ids)
        if employee_subdepartments_ids:
            notification.employee_subdepartments.set(employee_subdepartments_ids)

        try:
            notification.full_clean()  # این clean را با چک‌های ManyToMany اجرا می‌کنه
        except ValidationError as e:
            # اگر ارور داد، رکورد را delete کن و پیام خطا بده
            notification.delete()
            messages.error(request, f"خطا در اعتبارسنجی: {e}")
            return redirect("notification_create")

        notification.save()

        messages.success(request, "اعلان با موفقیت ایجاد شد.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    else:
        can_choose_holdings = True
        can_choose_factories = True
        can_choose_departments = True
        can_choose_subdepartments = True
        can_choose_employee = True
        holdings = None
        factories = None
        departments = None
        subdepartments = None

        if role_name in [
            "holding_manager",
            "factory_manager",
            "department_manager",
            "supervisor",
        ]:
            can_choose_holdings = False
            holdings = Holding.objects.filter(id=holding_id).first()
            if role_name in ["factory_manager", "department_manager", "supervisor"]:
                can_choose_factories = False
                factories = Factory.objects.filter(id=factory_id).first()
                if role_name in ["department_manager", "supervisor"]:
                    can_choose_departments = False
                    departments = Department.objects.filter(id=department_id).first()
                    if role_name in ["supervisor"]:
                        can_choose_subdepartments = False
                        subdepartments = Subdepartment.objects.filter(
                            id=subdepartment_id
                        ).first()
                    else:
                        subdepartments = Subdepartment.objects.filter(
                            department=departments
                        )
                else:
                    subdepartments = Subdepartment.objects.filter(
                        department__factory=factories
                    )
                    departments = Department.objects.filter(factory=factories)
            else:
                subdepartments = Subdepartment.objects.filter(
                    department__factory__holding=holdings
                )
                departments = Department.objects.filter(factory__holding=holdings)
                factories = Factory.objects.filter(holding=holdings)
        else:
            subdepartments = Subdepartment.objects.all()
            departments = Department.objects.all()
            factories = Factory.objects.all()
            holdings = Holding.objects.all()

        # GET: نمایش فرم خالی
        context = {
            "roles": Role.objects.all(),
            # 'holdings': [],
            "current_role": current_role,
            "can_choose_holdings": can_choose_holdings,
            "can_choose_factories": can_choose_factories,
            "can_choose_departments": can_choose_departments,
            "can_choose_subdepartments": can_choose_subdepartments,
            "can_choose_employee": can_choose_employee,
            "holdings": holdings,
            "factories": factories,
            "departments": departments,
            "subdepartments": subdepartments,
        }

        return render(request, "users/notification_create.html", context)


@login_required
def notifications_view(request):

    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    user = request.user

    notification_ids = []

    if role_name in [
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
        "employee",
    ]:

        if role_name in [
            "factory_manager",
            "department_manager",
            "supervisor",
            "employee",
        ]:

            if role_name in ["department_manager", "supervisor", "employee"]:

                if role_name in ["supervisor", "employee"]:

                    if role_name in ["employee"]:
                        notifications = Notification.objects.filter(
                            Q(employee_subdepartments__id=subdepartment_id)
                        ).distinct()
                    else:
                        notifications = Notification.objects.filter(
                            Q(target_subdepartments__id=subdepartment_id)
                        ).distinct()
                else:
                    notifications = Notification.objects.filter(
                        Q(target_departments__id=subdepartment_id)
                    ).distinct()
            else:
                notifications = Notification.objects.filter(
                    Q(target_factories__id=subdepartment_id)
                ).distinct()
        else:
            notifications = Notification.objects.filter(
                Q(target_holdings__id=subdepartment_id)
            ).distinct()
    else:
        # todo : super_admin
        pass

    # print(notifications)

    context = {
        # # اعلانات نمونه برای تب "موجود"
        # 'active_notifications': [
        #     {
        #         'id': 1,
        #         'title': 'یادآوری ارزیابی عملکرد',
        #         'message': 'مهلت ارزیابی ماهانه تا ۳ روز دیگر به پایان می‌رسد.',
        #         'date': '۱۴۰۴/۰۹/۲۵',
        #         'is_read': False,
        #     },
        #     {
        #         'id': 2,
        #         'title': 'رزرو غذا تأیید شد',
        #         'message': 'رزرو غذای شما برای فردا با موفقیت ثبت شد.',
        #         'date': '۱۴۰۴/۰۹/۲۴',
        #         'is_read': True,
        #     },
        # ],
        # # اعلانات نمونه برای تب "منقضی شده"
        # 'expired_notifications': [
        #     {
        #         'id': 3,
        #         'title': 'مهلت ارزیابی گذشته است',
        #         'message': 'ارزیابی عملکرد ماه آبان به پایان رسیده و قابل ثبت نیست.',
        #         'date': '۱۴۰۴/۰۹/۱۰',
        #     },
        #     {
        #         'id': 4,
        #         'title': 'تغییر شیفت (منقضی)',
        #         'message': 'درخواست تغییر شیفت شما بررسی و رد شد.',
        #         'date': '۱۴۰۴/۰۸/۱۵',
        #     },
        # ],
        # # برای بج تعداد اعلان خوانده نشده (فعلاً ثابت)
        # 'unread_notifications_count': 1,
    }

    return render(request, "users/notifications.html", context)


@login_required
def food_delivery_page(request):
    user = request.user
    today = date.today()

    # دسترسی
    if user.food_receiver_role == 0:
        messages.error(request, "شما دسترسی دریافت غذا ندارید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    # لیست کارخانه‌ها بر اساس نقش
    if user.food_receiver_role == 2:  # تحویل‌گیرنده هلدینگ
        if not user.food_receiver_holding:
            messages.error(request, "شما به هلدینگ خاصی وصل نیستید.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
        factories = Factory.objects.filter(holding=user.food_receiver_holding)
    else:  # role == 1 -> تحویل گیرنده کارخانه
        if not user.food_receiver_factory:
            messages.error(request, "شما به کارخانه‌ای وصل نیستید.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
        factories = Factory.objects.filter(id=user.food_receiver_factory.id)

    # گرفتن رزروهای امروز برای این کارخانه‌ها (که کنسل نشده و تحویل نشده)
    reservations = (
        FoodReservation.objects.filter(
            reservation_date=today,
            is_canceled=False,
            # is_delivered=False,
            related_factory__in=factories,
        )
        .select_related(
            "employee",
            "menu_item__food",
            "menu_item__weekly_menu__restaurant__department__factory",
            "related_factory",
        )
        .order_by(
            "related_factory__id",
            "menu_item__weekly_menu__restaurant__id",
            "menu_item__food__name",
        )
    )

    # ساختار داده: factories_map[factory] = { restaurant1: { food_id: {...} , ... }, restaurant2: {...} }
    factories_map = {}
    for fac in factories:
        factories_map[fac] = {}

    for r in reservations:
        fac = r.related_factory
        # استخراج رستوران واقعی از menu_item -> weekly_menu -> restaurant (Subdepartment)
        rest = r.menu_item.weekly_menu.restaurant  # Subdepartment
        food = r.menu_item.food
        food_key = food.id

        fac_entry = factories_map.setdefault(fac, {})
        rest_entry = fac_entry.setdefault(rest, {})

        # اگر غذای مشابه در همان رستوران وجود داشته باشه جمع می‌کنیم
        if food_key not in rest_entry:
            rest_entry[food_key] = {
                "food": food,
                "total": 0,
                "quota": 0,
                "extra": 0,
                "guest": 0,
                "reservations": [],
            }

        item = rest_entry[food_key]
        item["total"] += (
            (r.factory_quantity if r.factory_quantity != None else 0)
            + (r.free_quantity if r.free_quantity != None else 0)
            + (r.guest_quantity if r.guest_quantity != None else 0)
        )
        if r.factory_quantity and r.factory_quantity != 0:
            item["quota"] += r.factory_quantity
        if r.free_quantity and r.free_quantity != 0:
            item["extra"] += r.free_quantity
        if r.guest_quantity and r.guest_quantity != 0:
            item["guest"] += r.guest_quantity

        item["reservations"].append(r)

    # print(factories_map)

    # --- پردازش POST برای تأیید تحویل ---
    if request.method == "POST":

        reservation_id = request.POST.get("deliver_reservation")
        # print(reservation_id)

        reserved_food = FoodReservation.objects.filter(id=reservation_id).first()

        if reserved_food:
            # تغییر وضعیت به تحویل شده
            reserved_food.is_delivered = True

            # print(reserved_food)
            # ذخیره تغییرات در دیتابیس
            reserved_food.save(update_fields=["is_delivered"])

            return JsonResponse({"success": True, "message": "تحویل با موفقیت ثبت شد"})

    can_serve_foods = user.can_serve_foods
    context = {
        "factories_map": factories_map,
        "today": today,
        "role": user.food_receiver_role,
        "can_serve_foods": can_serve_foods,
    }
    return render(request, "users/food_delivery_page.html", context)


@login_required
def user_profile(request, user_id):
    user = get_object_or_404(Employee, pk=user_id)
    if request.user.role.name != "super_admin" and request.user != user:
        raise PermissionDenied("شما اجازه مشاهده این پروفایل را ندارید.")
    participations = Participation.objects.filter(user=user).order_by("-created_at")
    return render(
        request,
        "users/user_profile.html",
        {"user": user, "participations": participations},
    )


@login_required
def register_user(request):
    if request.user.role.name != "super_admin":
        raise PermissionDenied("شما اجازه ثبت کاربر جدید را ندارید.")
    if request.method == "POST":
        form = ParticipationForm(request.POST, request.FILES)
        if form.is_valid():
            participation = form.save(commit=False)
            participation.user = request.user
            participation.save()
            messages.success(request, "مشارکت با موفقیت ثبت شد.")
            # return redirect("users:dashboard")
            return redirect("users:landing")
    else:
        form = ParticipationForm()
    return render(request, "users/register_user.html", {"form": form})


@login_required
def management_dashboard(request):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    management_tree = request.session.get("management_tree", [])
    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]
    is_committee = request.session["current_is_committee"]
    real_role = request.session["current_real_role"]

    user = request.user

    has_management_access = role_name in management_roles
    can_access_evaluation_panel = role_name in ["super_admin", "department_manager"]

    # print(role_name, holding_id, factory_id, department_id, subdepartment_id, is_committee)

    if role_name not in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]:
        raise PermissionDenied("شما مجاز به دسترسی به این بخش نیستید.")

    form = ManagementFilterForm(request.GET or None)

    # فیلتر اولیه بر اساس نقش فعلی (از سشن)
    all_participations = Participation.objects.none()
    all_employees = Employee.objects.none()

    if role_name == "super_admin":
        all_participations = Participation.objects.filter().order_by("-created_at")
        all_employees = Employee.objects.all()
    elif role_name == "holding_manager":
        all_participations = Participation.objects.filter(
            Q(holding_id=holding_id)
            | Q(factory_committee__linked_factory__holding_id=holding_id)
        ).order_by("-created_at")
        all_employees = Employee.objects.filter(
            assigned_subdepartments__department__factory__holding_id=holding_id
        ).distinct()

    elif role_name == "factory_manager":
        if is_committee:
            all_participations = Participation.objects.filter(
                Q(factory_committee_id=factory_id, is_committee=is_committee)
                # | Q(factory_committee__linked_factory_id=factory_id, is_committee=is_committee)
            ).order_by("-created_at")
        else:
            all_participations = Participation.objects.filter(
                factory_id=factory_id, is_committee=is_committee
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__department__factory_id=factory_id
            ).distinct()
    elif role_name == "department_manager":
        if is_committee:
            # print(f"dep id {department_id}")

            all_participations = Participation.objects.filter(
                department_committee_id=department_id, is_committee=is_committee
            ).order_by("-created_at")

            # print(f"par           {all_participations}")
        else:
            all_participations = Participation.objects.filter(
                department_id=department_id, is_committee=is_committee
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__department_id=department_id
            ).distinct()
    elif role_name == "supervisor":
        if is_committee:
            all_participations = Participation.objects.filter(
                subdepartment_committee_id=subdepartment_id, is_committee=is_committee
            ).order_by("-created_at")
        else:
            all_participations = Participation.objects.filter(
                subdepartment_id=subdepartment_id, is_committee=is_committee
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__id=subdepartment_id
            ).distinct()

    can_choose_subdepartment = False
    can_choose_department = False
    can_choose_factory = False
    can_choose_holding = False

    if role_name in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    ]:
        can_choose_subdepartment = True
        if role_name in ["super_admin", "holding_manager", "factory_manager"]:
            can_choose_department = True
            if role_name in ["super_admin", "holding_manager"]:
                can_choose_factory = True
                if role_name in ["super_admin"]:
                    can_choose_holding = True

    selected_holding_id = request.GET.get("holding", "").strip() or None
    selected_factory_id = request.GET.get("factory", "").strip() or None
    selected_department_id = request.GET.get("department", "").strip() or None
    selected_subdepartment_id = request.GET.get("subdepartment", "").strip() or None
    selected_status = request.GET.get("status", "").strip() or None
    selected_item_type = request.GET.get("item_type", "").strip() or None
    selected_is_committee = request.GET.get("is_committee", "").strip() or None
    selected_employee_id = request.GET.get("search") or None

    # print(selected_employee_id)

    # منطق تعیین مقدار selected بر اساس دسترسی
    # اعمال خودکار مقادیر سشن وقتی کاربر اجازه انتخاب نداره
    if not can_choose_holding and holding_id:
        selected_holding_id = holding_id

    if not can_choose_factory and factory_id:
        selected_factory_id = factory_id

    if not can_choose_department and department_id:
        selected_department_id = department_id

    if not can_choose_subdepartment and subdepartment_id:
        selected_subdepartment_id = subdepartment_id

    # حالا اگر کاربر "همه" انتخاب کرد (یعنی خالی ارسال کرد)، None در نظر بگیر
    if selected_holding_id == "":
        selected_holding_id = None
    if selected_factory_id == "":
        selected_factory_id = None
    if selected_department_id == "":
        selected_department_id = None
    if selected_subdepartment_id == "":
        selected_subdepartment_id = None

    # حالا کوئری مشارکت‌ها بر اساس این فیلترها
    # participations = Participation.objects.all().order_by('-created_at')
    participations = all_participations

    if selected_holding_id:
        print("h")
        participations = participations.filter(
            # holding_id=selected_holding_id
            Q(holding_id=selected_holding_id)
            | Q(factory_committee__linked_factory_id=selected_holding_id)
        )

    if selected_factory_id:
        if is_committee:
            participations = participations.filter(
                factory_committee_id=selected_factory_id
            )
        else:
            participations = participations.filter(factory_id=selected_factory_id)
    if selected_department_id:
        if is_committee:
            participations = participations.filter(
                department_committee_id=selected_department_id
            )
        else:
            participations = participations.filter(department_id=selected_department_id)
    if selected_subdepartment_id:
        if is_committee:
            participations = participations.filter(
                subdepartment_committee_id=selected_subdepartment_id
            )
        else:
            participations = participations.filter(
                subdepartment_id=selected_subdepartment_id
            )

    if selected_status:
        participations = participations.filter(status=selected_status)
    if selected_item_type:
        participations = participations.filter(item_type=selected_item_type)
    if selected_is_committee:
        participations = participations.filter(is_committee=selected_is_committee)
    if selected_employee_id:
        participations = participations.filter(user_id=selected_employee_id)

    # participations = participations[:PARTICIPATIONS_PER_LOAD]

    holdings = Holding.objects.values("id", "name")
    factories = Factory.objects.values("id", "name", "holding_id")
    departments = Department.objects.values("id", "name", "factory_id")
    subdepartments = Subdepartment.objects.values("id", "name", "department_id")

    total_count = participations.count()  # شمارش کل QuerySet اصلی

    # فقط 50 تای اول را برای بارگذاری اولیه انتخاب می کنیم

    remaining_count = total_count - len(participations)

    participation_counts = {
        item_type[0]: participations.filter(item_type=item_type[0]).count()
        for item_type in Participation.ITEM_TYPES
    }
    # participation_display = [
    #     {'display': label, 'count': participation_counts.get(key, 0), 'audio_count': 0}
    #     for key, label in Participation.ITEM_TYPES
    # ]

    audio_count = all_participations.filter(is_audio=True).count()
    # other_count = all_participations.filter(is_audio=False).count()

    other_count = all_participations.filter(
        Q(is_audio=False) & ~Q(attachment__isnull=True) & ~Q(attachment="")
    ).count()

    participation_display = [
        {
            "display": label,
            "count": participation_counts.get(key, 0),
            "audio_count": all_participations.filter(
                item_type=key, is_audio=True
            ).count(),
        }
        for key, label in Participation.ITEM_TYPES
    ]

    # 🌟 جدید: محاسبات مشارکت امروز و هزینه‌ها

    tehran_aware_datetime = timezone.localtime(timezone.now())
    today = tehran_aware_datetime.date()
    start_of_day = timezone.make_aware(datetime.combine(today, time.min))
    end_of_day = timezone.make_aware(datetime.combine(today, time.max))

    today_participations = participations.filter(
        created_at__gte=start_of_day, created_at__lte=end_of_day
    )

    # today_participations = all_participations.filter(created_at__date=today)
    today_count = today_participations.count()
    # ۱. میزان اضافه کاری مشارکت کل
    total_overtime_cost = total_count * BASE_COST_PER_PARTICIPATION
    # ۳. میزان اضافه کاری مشارکت امروز
    today_overtime_cost = today_count * BASE_COST_PER_PARTICIPATION

    participation_counts = {
        item_type[0]: participations.filter(item_type=item_type[0]).count()
        for item_type in Participation.ITEM_TYPES
    }
    # audio_count = participations.filter(item_type='performance_file').count()
    # other_count = participations.exclude(item_type='performance_file').count()

    chart_data = (
        json.dumps(list(participation_counts.values()))
        if participation_counts
        else json.dumps([0, 0, 0, 0, 0])
    )

    total_users = all_employees.count()
    total_evaluations = Evaluation.objects.filter(user__in=all_employees).count()

    # داده‌های نمودار
    labels = [label for _, label in Participation.ITEM_TYPES]
    data = list(participation_counts.values())

    has_more = remaining_count > 0
    reviewers = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]

    if request.method == "POST" and request.POST.get("action") == "export_excel":
        data_columns = [
            (
                "کارمند",
                [p.user.full_name if p.user else "نامشخص" for p in participations],
            ),
            ("عنوان مشارکت", [p.title or "" for p in participations]),
            ("نوع مشارکت", [p.get_item_type_display() for p in participations]),
            (
                "تاریخ ثبت",
                [p.created_at for p in participations],
            ),  # خود تاریخ → تابع تبدیل می‌کنه
            ("وضعیت", [p.get_status_display() for p in participations]),
        ]

        return export_to_excel(
            columns=data_columns,
            filename=f"گزارش_مشارکت‌ها_{jdatetime.datetime.now().strftime('%Y%m%d')}",
            report_title="گزارش جامع مشارکت‌های سیستم",
        )

    participations = participations[:PARTICIPATIONS_PER_LOAD]

    user_is_self_manager = False

    if (
        Department.objects.filter(
            Q(id=department_id),
            Q(is_self=True),
            # Q(manager=request.user) |
            Q(managers=request.user),
        )
        and role_name == "department_manager"
    ):
        user_is_self_manager = True

    user_is_restaurant = False
    if (
        Subdepartment.objects.filter(
            Q(id=subdepartment_id),
            Q(is_restaurant=True),
            # Q(supervisor=request.user) |
            Q(supervisors=request.user),
        )
        and role_name == "supervisor"
    ):
        user_is_restaurant = True

    can_import_excel = role_name == "super_admin"

    can_manage_bimeh = role_name in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
    ]

    # factory_bimeh = user.factory_bimeh
    # holding_bimeh = user.holding_bimeh

    # can_manage_bimeh = factory_bimeh or holding_bimeh

    return render(
        request,
        "users/dashboard_management.html",
        {
            "form": form,
            "participations": participations,  # فقط 50 تای اول
            "remaining_count": remaining_count,  # تعداد باقی مانده
            "has_more": has_more,  # آیا موارد بیشتری برای بارگذاری وجود دارد؟
            "employees": all_employees,  # فهرست کارمندان نیازی به بارگذاری تنبل ندارد
            "user": user,
            "participation_display": participation_display,
            "audio_count": audio_count,
            "other_count": other_count,
            "chart_data": chart_data,
            "total_participations": total_count,
            "total_users": total_users,
            "total_evaluations": total_evaluations,
            "labels": json.dumps(labels),
            "data": json.dumps(data),
            "management": True,
            "reviewers": reviewers,
            "can_access_evaluation_panel": can_access_evaluation_panel,
            "base_cost": BASE_COST_PER_PARTICIPATION,
            "total_overtime_cost": total_overtime_cost,
            "today_count": today_count,  # ۲. تعداد مشارکت های امروز
            "today_overtime_cost": today_overtime_cost,
            "total_count": total_count,
            "role_name": role_name,
            "holding_id": holding_id,
            "factory_id": factory_id,
            "department_id": department_id,
            "subdepartment_id": subdepartment_id,
            "can_choose_holding": can_choose_holding,
            "can_choose_factory": can_choose_factory,
            "can_choose_department": can_choose_department,
            "can_choose_subdepartment": can_choose_subdepartment,
            # مقادیر انتخاب شده نهایی (برای فرم و کوئری)
            "selected_holding_id": selected_holding_id or "",
            "selected_factory_id": selected_factory_id or "",
            "selected_department_id": selected_department_id or "",
            "selected_subdepartment_id": selected_subdepartment_id or "",
            "holdings": Holding.objects.all(),
            "holdings_json": json.dumps(list(holdings), cls=DjangoJSONEncoder),
            "factories_json": json.dumps(list(factories), cls=DjangoJSONEncoder),
            "departments_json": json.dumps(list(departments), cls=DjangoJSONEncoder),
            "subdepartments_json": json.dumps(
                list(subdepartments), cls=DjangoJSONEncoder
            ),
            "participation_status_choices": Participation.STATUS_CHOICES,
            "participation_item_type_choices": Participation.ITEM_TYPES,
            "selected_status": selected_status,
            "selected_item_type": selected_item_type,
            "user_is_self_manager": user_is_self_manager,
            "user_is_restaurant": user_is_restaurant,
            "can_import_excel": can_import_excel,
            # "can_manage_bimeh": can_manage_bimeh,
        },
    )


def search_employees(request):
    q = request.GET.get("q", "").strip()
    print(q)
    if len(q) < 2:
        return JsonResponse([], safe=False)

    employees = Employee.objects.filter(is_active=True).filter(
        Q(first_name__icontains=q)
        | Q(last_name__icontains=q)
        # | Q(full_name__icontains=q)
        | Q(national_id__icontains=q)
        | Q(personnel_code__icontains=q)
    )[
        :20
    ]  # حداکثر 20 نتیجه

    results = []
    for emp in employees:
        results.append(
            {
                "id": emp.id,
                "text": emp.full_name,
                "national_id": emp.national_id,
                "personnel_code": emp.personnel_code or "ندارد",
            }
        )

    return JsonResponse(results, safe=False)


@login_required
def manage_self_menu(request):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    management_tree = request.session.get("management_tree", [])
    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]
    is_committee = request.session["current_is_committee"]
    real_role = request.session["current_real_role"]

    user = request.user

    print(f"role: {role_name}")

    has_management_access = role_name in management_roles
    can_access_evaluation_panel = role_name in ["super_admin", "department_manager"]

    can_download_other_factories_resers = True

    # دسترسی فقط برای مدیر سلف
    if (
        role_name != "department_manager"
        or not Department.objects.filter(
            # Q(manager=request.user) |
            Q(managers=request.user),
            is_self=True,
        ).exists()
    ):
        messages.error(request, "شما دسترسی به مدیریت منوی سلف ندارید.")
        return redirect("users:landing")

    # رستوران‌ها
    restaurants = (
        Subdepartment.objects.filter(
            # Q(department__manager=request.user) |
            Q(department__managers=request.user),
            department_id=department_id,
            department__is_self=True,
            is_restaurant=True,
        )
        .select_related("department__factory")
        .distinct()
    )

    today_gdate = date.today()
    today_jdate = jdatetime.date.today()

    days_until_this_saturday = today_jdate.weekday()
    this_saturday_gdate = (
        today_jdate - timedelta(days=days_until_this_saturday)
    ).togregorian()
    save_week_start_gdate = this_saturday_gdate + timedelta(days=7)  # همیشه هفته آینده
    save_week_start_persian = jdatetime.date.fromgregorian(
        date=save_week_start_gdate
    ).strftime("%Y/%m/%d")

    # 2. پیدا کردن آخرین منوی موجود برای نمایش (حتی اگر مال هفته‌های قبل باشه)
    latest_menu_any = (
        WeeklyMenu.objects.filter(restaurant__in=restaurants)
        .order_by("-week_start_date")
        .first()
    )

    if latest_menu_any:
        display_week_start_gdate = latest_menu_any.week_start_date
    else:
        # اگر هیچ منویی وجود نداشت، هفته آینده رو نشون بده
        display_week_start_gdate = save_week_start_gdate

    display_week_start_persian = jdatetime.date.fromgregorian(
        date=display_week_start_gdate
    ).strftime("%Y/%m/%d")

    # متغیرهایی که به تمپلیت و ذخیره می‌فرستیم
    week_start_for_save = save_week_start_gdate
    week_start_for_display = display_week_start_gdate
    week_start_persian = display_week_start_persian

    # همه غذاها
    all_foods = FoodItem.objects.filter(is_active=True).order_by("name")

    # روزهای هفته
    days = [
        ("shanbe", "شنبه"),
        ("1shanbe", "یکشنبه"),
        ("2shanbe", "دوشنبه"),
        ("3shanbe", "سه‌شنبه"),
        ("4shanbe", "چهارشنبه"),
        ("5shanbe", "پنج‌شنبه"),
        ("jome", "جمعه"),
    ]

    # آماده‌سازی داده برای تمپلیت
    restaurant_data = []
    for restaurant in restaurants:
        menu = restaurant.weekly_menus.filter(
            week_start_date=display_week_start_gdate
        ).first()

        selected_foods_status = {}
        if menu:
            for item in menu.items.all():
                day = item.day_persian
                food_id = item.food.id

                key = f"{food_id}:{day}"

                # مقداردهی کلید ترکیبی
                selected_foods_status[key] = True  # فقط وجود کلید مهم است
        restaurant_data.append(
            {
                "restaurant": restaurant,
                # 'selected_foods': selected_foods,
                "selected_items": selected_foods_status,
            }
        )

    context = {
        "restaurant_data": restaurant_data,
        "all_foods": all_foods,
        "days": days,
        "week_start_persian": display_week_start_persian,
        "no_restaurant": not restaurants.exists(),
        "save_week_start_persian": save_week_start_persian,
        "can_download_other_factories_resers": can_download_other_factories_resers,
    }

    if request.GET.get("export") == "full":
        print(f"vvvvvvvvvvvv{request}")
        start_date = request.GET.get("start_date")
        end_date = request.GET.get("end_date")

        # print(f"{}")

        jalali_str = start_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        strt_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        jalali_str = end_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        end_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        # if can_download_other_factories_resers:
        # factory_id = [1, 9, 12, 11]
        # factory_id = [12]
        # factory_id = [1, 12]
        factory_id = [factory_id]

        # دریافت تمام رستوران‌های مربوط به این کارخانه
        restaurants = Subdepartment.objects.filter(
            is_restaurant=True, department__factory_id__in=factory_id
        ).order_by("name")

        employees = Employee.objects.filter()

        restaurant_stats = {}

        # برای هر رستوران، تعداد سفارشات در بازه تاریخ را محاسبه می‌کنیم
        for restaurant in restaurants:
            total_orders = (
                FoodReservation.objects.filter(
                    menu_item__weekly_menu__restaurant=restaurant,
                    reservation_date__gte=strt_gregorian_date,
                    reservation_date__lte=end_gregorian_date,
                    related_factory_id__in=factory_id,
                    is_canceled=0,
                ).aggregate(
                    total=Sum("factory_quantity")
                    + Sum("free_quantity")
                    + Sum("guest_quantity")
                )[
                    "total"
                ]
                or 0
            )

            restaurant_stats[restaurant.id] = {
                "name": restaurant.name,
                "total_orders": total_orders,
            }

        # لیست داده‌ها برای اکسل
        rows_full_name = []
        rows_national_id = []
        rows_personnel_code = []
        rows_phone = []
        rows_total_debt_raw = []  # عدد خام
        rows_total_debt_formatted = []  # با کاما و ریال
        rows_center_of_charge = []

        rows_total_factory_qty = []
        rows_total_free_qty = []
        rows_total_guest_qty = []

        # ستون‌های جدید برای آمار رستوران‌ها
        restaurant_columns = {}
        for restaurant in restaurants:
            restaurant_columns[restaurant.id] = []

        for emp in employees:
            reservations = FoodReservation.objects.filter(
                employee=emp,
                related_factory_id__in=factory_id,
                reservation_date__gte=strt_gregorian_date,
                reservation_date__lte=end_gregorian_date,
                is_canceled=0,
            )

            total_debt = reservations.aggregate(total=Sum("total_price"))["total"] or 0
            factory_quantity = (
                reservations.aggregate(total=Sum("factory_quantity"))["total"] or 0
            )
            free_quantity = (
                reservations.aggregate(total=Sum("free_quantity"))["total"] or 0
            )
            guest_quantity = (
                reservations.aggregate(total=Sum("guest_quantity"))["total"] or 0
            )

            if (
                total_debt == 0
                and factory_quantity == 0
                and free_quantity == 0
                and guest_quantity == 0
            ):
                continue

            # محاسبه تعداد سفارشات برای هر رستوران
            for restaurant in restaurants:
                restaurant_orders_count = (
                    reservations.filter(
                        menu_item__weekly_menu__restaurant=restaurant, is_canceled=0
                    ).aggregate(
                        total=Sum("factory_quantity")
                        + Sum("free_quantity")
                        + Sum("guest_quantity")
                    )[
                        "total"
                    ]
                    or 0
                )

                restaurant_columns[restaurant.id].append(restaurant_orders_count)

            rows_full_name.append(emp.full_name or "نامشخص")
            rows_national_id.append(emp.national_id)
            rows_personnel_code.append(emp.personnel_code or "-")
            rows_phone.append(emp.phone_number or "-")
            rows_total_debt_raw.append(total_debt)

            rows_total_factory_qty.append(factory_quantity)
            rows_total_free_qty.append(free_quantity)
            rows_total_guest_qty.append(guest_quantity)

            rows_total_debt_formatted.append(
                f"{total_debt:,} ریال" if total_debt > 0 else "بدون بدهی"
            )

            rows_center_of_charge.append(emp.center_of_charge or "نامشخص")

        # مرتب‌سازی بر اساس مبلغ بدهی (نزولی)

        try:
            combined_list = list(
                zip(
                    rows_full_name,
                    rows_national_id,
                    rows_personnel_code,
                    rows_phone,
                    rows_total_debt_raw,
                    rows_total_factory_qty,
                    rows_total_free_qty,
                    rows_total_guest_qty,
                    rows_total_debt_formatted,
                    rows_center_of_charge,
                    *[restaurant_columns[restaurant.id] for restaurant in restaurants],
                )
            )

            combined_list.sort(
                key=lambda x: x[4], reverse=True
            )  # بر اساس total_debt_raw

            # جدا کردن دوباره بعد از سورت
            sorted_data = list(zip(*combined_list))

            # ستون‌های اصلی
            rows_full_name = sorted_data[0]
            rows_national_id = sorted_data[1]
            rows_personnel_code = sorted_data[2]
            rows_phone = sorted_data[3]
            rows_total_debt_raw = sorted_data[4]
            rows_total_factory_qty = sorted_data[5]
            rows_total_free_qty = sorted_data[6]
            rows_total_guest_qty = sorted_data[7]
            rows_total_debt_formatted = sorted_data[8]
            rows_center_of_charge = sorted_data[9]

            restaurant_sorted_columns = {}
            for i, restaurant in enumerate(restaurants, start=10):
                restaurant_sorted_columns[restaurant.id] = sorted_data[i]

            # ستون‌های نهایی
            data_columns = [
                ("نام و نام خانوادگی", list(rows_full_name)),
                ("کد ملی", list(rows_national_id)),
                ("کد پرسنلی", list(rows_personnel_code)),
                ("شماره تماس", list(rows_phone)),
                ("تعداد سفارشات سهمیه ای", rows_total_factory_qty),
                ("تعداد سفارشات آزاد", rows_total_free_qty),
                ("تعداد سفارشات مهمان", rows_total_guest_qty),
                ("مبلغ بدهی", list(rows_total_debt_formatted)),
                ("مرکز هزینه", list(rows_center_of_charge)),
            ]

            for restaurant in restaurants:
                column_name = f"{restaurant.name} (تعداد سفارش)"
                data_columns.append(
                    (column_name, list(restaurant_sorted_columns[restaurant.id]))
                )

            # اضافه کردن یک ردیف خلاصه برای کل سفارشات هر رستوران
            summary_row = []
            for restaurant in restaurants:
                summary_row.append(restaurant_stats[restaurant.id]["total_orders"])

            # نام فایل و عنوان گزارش
            today_jalali = jdatetime.date.today().strftime("%Y/%m/%d")
            filename = f"Bedehi_Kol_Self_{today_jalali.replace('/', '-')}"
            report_title = f"گزارش کامل بدهی پرسنل به سلف - تولید شده در {today_jalali}"

            return export_to_excel(
                columns=data_columns,
                filename=filename,
                report_title=report_title,
                restaurant_stats=restaurant_stats,
                summary_row=summary_row,
            )
        except Exception as e:
            messages.error(request, f"در این بازه زمانی اطلاعاتی در دسترس نیست!!! {e}")
            return redirect("users:manage_self_menu")

    elif request.GET.get("export") == "full-restaurant":

        start_date = request.GET.get("start_date")
        end_date = request.GET.get("end_date")

        # print(start_date)
        # print(end_date)

        jalali_str = start_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        strt_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        jalali_str = end_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        end_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        reservations = (
            FoodReservation.objects.filter(
                # related_factory_id=factory_id,
                reservation_date__gte=strt_gregorian_date,
                reservation_date__lte=end_gregorian_date,
                is_canceled=0,
                menu_item__weekly_menu__restaurant__is_restaurant=True,
            )
            .values(
                "reservation_date",
                "menu_item__weekly_menu__restaurant__name",
            )
            .annotate(
                total_orders=Sum("factory_quantity")
                + Sum("free_quantity")
                + Sum("guest_quantity")
            )
            .order_by("reservation_date")
        )

        daily_stats = defaultdict(dict)

        for r in reservations:
            daily_stats[r["reservation_date"]][
                r["menu_item__weekly_menu__restaurant__name"]
            ] = (r["total_orders"] or 0)

        restaurants = list(
            Subdepartment.objects.filter(
                is_restaurant=True,
                # department__factory_id=factory_id
            ).values_list("name", flat=True)
        )

        dates = sorted(daily_stats.keys())

        data_columns = [
            (
                "تاریخ",
                [
                    jdatetime.date.fromgregorian(date=d).strftime("%Y/%m/%d")
                    for d in dates
                ],
            )
        ]

        for r in restaurants:
            data_columns.append(
                (
                    r,
                    [daily_stats[d].get(r, 0) for d in dates],
                )
            )

        today_jalali = jdatetime.date.today().strftime("%Y/%m/%d")
        filename = f"Restaurant_Daily_Report_{today_jalali.replace('/', '-')}"
        report_title = f"گزارش روزانه سفارش رستوران‌ها - {today_jalali}"

        return export_to_excel(
            columns=data_columns,
            filename=filename,
            report_title=report_title,
        )

    elif request.GET.get("export") == "single" and request.GET.get("employee_id"):
        start_date = request.GET.get("start_date")
        end_date = request.GET.get("end_date")

        # print(f"{}")

        jalali_str = start_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        strt_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        jalali_str = end_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        end_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        employee_id = request.GET.get("employee_id")
        try:
            employee = Employee.objects.get(id=employee_id)
        except Employee.DoesNotExist:
            messages.error(request, "کارمند یافت نشد.")
            return redirect(request.path)

        # گرفتن تمام رزروهای تحویل‌شده و لغو نشده
        reservations = (
            FoodReservation.objects.filter(
                employee=employee,
                reservation_date__gte=strt_gregorian_date,
                reservation_date__lte=end_gregorian_date,
            )
            .select_related("menu_item__food", "menu_item__weekly_menu__restaurant")
            .order_by("-reservation_date")
        )

        # ساخت داده‌های اکسل
        col_names = [
            "تاریخ رزرو",
            "روز هفته",
            "رستوران",
            "غذا",
            "تعداد کارخانه",
            "تعداد آزاد",
            "تعداد مهمان",
            "هزینه کل سفارش (ریال)",
        ]

        rows_date = []
        rows_day = []
        rows_restaurant = []
        rows_food = []
        rows_factory_qty = []
        rows_free_qty = []
        rows_guest_qty = []
        rows_total_price = []
        reserver = []

        total_debt = 0

        for res in reservations:
            jalali_date = jdatetime.date.fromgregorian(date=res.reservation_date)
            day_name = jalali_date.strftime("%A")  # شنبه، یکشنبه و...

            if str(res.reserved_by) != "0":
                employee_reserver = Employee.objects.filter(
                    id=int(res.reserved_by)
                ).first()
                if employee_reserver:
                    reserver_name = employee_reserver.full_name
                else:
                    reserver_name = "ناشناس"
            else:
                reserver_name = (
                    Employee.objects.filter(id=res.employee_id).first().full_name
                )

            rows_date.append(jalali_date.strftime("%Y/%m/%d"))
            rows_day.append(day_name)
            rows_restaurant.append(res.menu_item.weekly_menu.restaurant.name)
            rows_food.append(res.menu_item.food.name)
            rows_factory_qty.append(res.factory_quantity)
            rows_free_qty.append(res.free_quantity)
            rows_guest_qty.append(res.guest_quantity)
            rows_total_price.append(res.total_price)
            reserver.append(reserver_name)

            total_debt += res.total_price

        # ستون‌ها
        data_columns = [
            ("تاریخ رزرو", rows_date),
            ("روز هفته", rows_day),
            ("رستوران", rows_restaurant),
            ("غذا", rows_food),
            ("تعداد سهمیه", rows_factory_qty),
            ("تعداد آزاد", rows_free_qty),
            ("تعداد مهمان", rows_guest_qty),
            ("هزینه کل سفارش (ریال)", rows_total_price),
            ("رزرو کننده", reserver),
        ]

        today = jdatetime.date.today().strftime("%Y-%m-%d")
        filename = f"Bedehi_{employee.full_name.replace(' ', '_')}_{today}"
        print()
        report_title = f"گزارش کامل رزروهای غذا - {employee.full_name} (کد ملی: {employee.national_id}) - مجموع بدهی: {total_debt:,} ریال"

        return export_to_excel(
            columns=data_columns, filename=filename, report_title=report_title
        )

    # ==================== POST ====================
    if request.method == "POST":
        action = request.POST.get("action")

        # حالت اول: ثبت غذای جدید
        if request.POST.get("add_food") or action == "add_food":
            name = request.POST.get("food_name", "").strip()
            price_raw = request.POST.get("food_price", "")
            free_price_row = request.POST.get("food_free_price", "")
            is_management_food = request.POST.get("is_management_food") == "1"

            if not name:
                messages.error(request, "نام غذا نمی‌تواند خالی باشد.")
            elif not price_raw.isdigit():
                messages.error(request, "قیمت کارخانه را مشخص نکرده اید.")
            elif not free_price_row.isdigit():
                messages.error(request, "قیمت آزاد را مشخص نکرده اید.")
            else:
                price = int(price_raw)
                free_price = int(free_price_row)
                food, created = FoodItem.objects.update_or_create(
                    name__iexact=name,
                    defaults={
                        "name": name,
                        "factory_price": price,
                        "is_active": True,
                        "free_price": free_price,
                        "is_management_food": is_management_food,
                    },
                )
                verb = "اضافه" if created else "به‌روزرسانی"
                messages.success(request, f"غذا «{name}» با موفقیت {verb} شد.")

            return redirect("users:manage_self_menu")

        # حالت دوم: ذخیره منوی هفتگی
        elif action == "save_menu":
            saved = 0
            for restaurant in restaurants:
                menu, _ = WeeklyMenu.objects.get_or_create(
                    restaurant=restaurant,
                    week_start_date=week_start_for_save,
                    defaults={"is_active": True},
                )
                menu.items.all().delete()

                for food in all_foods:
                    for day_code, _ in days:
                        key = f"food_{restaurant.id}_{food.id}_{day_code}"
                        if request.POST.get(key):
                            MenuItem.objects.create(
                                weekly_menu=menu, food=food, day_persian=day_code
                            )
                            saved += 1

            messages.success(request, f"منوی هفتگی با موفقیت ذخیره شد ({saved} مورد)")
            return redirect("users:manage_self_menu")

        else:
            messages.error(request, "عملیات نامشخص بود.")
            return redirect("users:manage_self_menu")

    # ==================== GET ====================
    return render(request, "users/manage_self_menu.html", context)


@login_required
def managements_reports_dashboard(request):
    user = request.user
    # factory_id = 2

    # print(f"user : {user.id} , in reporting panel")

    """داشبورد گزارش‌گیری - نمایش صفحه اصلی با کارت‌های آماری"""
    # بررسی دسترسی مدیر سلف
    # if not Department.objects.filter(managers=request.user, reporting_permision=0).exists():
    #     pass

    # print(f"print : {user.reporting_permision}")

    if user.reporting_permision == 0:
        messages.error(request, "شما دسترسی به صفحه گزارش‌گیری ندارید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    # آمار برای کارت‌ها
    total_employees = Employee.objects.filter(is_active=True).count()
    total_restaurants = Subdepartment.objects.filter(is_restaurant=True).count()
    today_reservations = FoodReservation.objects.filter(
        reservation_date=date.today(), is_canceled=0
    ).count()

    factory_ids_param = request.GET.get("factory_ids", "")

    # تبدیل رشته "1,3,5" به لیست اعداد صحیح
    factory_ids = []
    if factory_ids_param:
        try:
            factory_ids = [
                int(id_str) for id_str in factory_ids_param.split(",") if id_str.strip()
            ]
        except ValueError:
            factory_ids = []

    if not factory_ids or factory_ids == []:
        factory_ids = list(Factory.objects.values_list("id", flat=True))

    # print(f"fffffffffffffff{factory_ids}")

    if request.GET.get("export") == "full":
        start_date = request.GET.get("start_date")
        end_date = request.GET.get("end_date")

        # print(f"{}")

        jalali_str = start_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        strt_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        jalali_str = end_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        end_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        # if can_download_other_factories_resers:
        # factory_id = [1, 9, 12, 11]
        # factory_id = [12]
        # factory_id = [1, 12]
        # factory_id = [factory_id]

        factory_id = factory_ids

        # دریافت تمام رستوران‌های مربوط به این کارخانه
        restaurants = Subdepartment.objects.filter(
            is_restaurant=True, department__factory_id__in=factory_id
        ).order_by("name")

        employees = Employee.objects.filter()

        restaurant_stats = {}

        # برای هر رستوران، تعداد سفارشات در بازه تاریخ را محاسبه می‌کنیم
        for restaurant in restaurants:
            total_orders = (
                FoodReservation.objects.filter(
                    menu_item__weekly_menu__restaurant=restaurant,
                    reservation_date__gte=strt_gregorian_date,
                    reservation_date__lte=end_gregorian_date,
                    related_factory_id__in=factory_id,
                    is_canceled=0,
                ).aggregate(
                    total=Sum("factory_quantity")
                    + Sum("free_quantity")
                    + Sum("guest_quantity")
                )[
                    "total"
                ]
                or 0
            )

            restaurant_stats[restaurant.id] = {
                "name": restaurant.name,
                "total_orders": total_orders,
            }

        # لیست داده‌ها برای اکسل
        rows_full_name = []
        rows_national_id = []
        rows_personnel_code = []
        rows_phone = []
        rows_total_debt_raw = []  # عدد خام
        rows_total_debt_formatted = []  # با کاما و ریال
        rows_center_of_charge = []
        Position_Job_history = []
        Place_of_service_recruitment_order = []
        rows_factory_names = []

        rows_total_factory_qty = []
        rows_total_free_qty = []
        rows_total_guest_qty = []

        # ستون‌های جدید برای آمار رستوران‌ها
        restaurant_columns = {}
        for restaurant in restaurants:
            restaurant_columns[restaurant.id] = []

        for emp in employees:
            reservations = FoodReservation.objects.filter(
                employee=emp,
                related_factory_id__in=factory_id,
                reservation_date__gte=strt_gregorian_date,
                reservation_date__lte=end_gregorian_date,
                is_canceled=0,
            )

            if emp.id == 1311:
                for res in reservations:
                    if res.reserved_by != 0:
                        # print(f"ffffffffffff : {res.reserved_by}")
                        pass

            total_debt = reservations.aggregate(total=Sum("total_price"))["total"] or 0
            factory_quantity = (
                reservations.aggregate(total=Sum("factory_quantity"))["total"] or 0
            )
            free_quantity = (
                reservations.aggregate(total=Sum("free_quantity"))["total"] or 0
            )
            guest_quantity = (
                reservations.aggregate(total=Sum("guest_quantity"))["total"] or 0
            )

            if (
                total_debt == 0
                and factory_quantity == 0
                and free_quantity == 0
                and guest_quantity == 0
            ):
                continue

            # محاسبه تعداد سفارشات برای هر رستوران
            for restaurant in restaurants:
                restaurant_orders_count = (
                    reservations.filter(
                        menu_item__weekly_menu__restaurant=restaurant, is_canceled=0
                    ).aggregate(
                        total=Sum("factory_quantity")
                        + Sum("free_quantity")
                        + Sum("guest_quantity")
                    )[
                        "total"
                    ]
                    or 0
                )

                restaurant_columns[restaurant.id].append(restaurant_orders_count)

            rows_full_name.append(emp.full_name or "نامشخص")
            rows_national_id.append(emp.national_id)
            rows_personnel_code.append(emp.personnel_code or "-")
            rows_phone.append(emp.phone_number or "-")
            rows_total_debt_raw.append(total_debt)

            rows_total_factory_qty.append(factory_quantity)
            rows_total_free_qty.append(free_quantity)
            rows_total_guest_qty.append(guest_quantity)

            rows_total_debt_formatted.append(
                f"{total_debt:,} ریال" if total_debt > 0 else "بدون بدهی"
            )

            rows_center_of_charge.append(emp.center_of_charge or "نامشخص")
            Position_Job_history.append(emp.Position_Job_history or "نامشخص")
            Place_of_service_recruitment_order.append(
                emp.Place_of_service_recruitment_order or "نامشخص"
            )

            factory_names_set = set()
            for reservation in reservations:
                if reservation.related_factory:
                    factory_names_set.add(reservation.related_factory.name)

            factory_names_str = (
                "، ".join(factory_names_set) if factory_names_set else "-"
            )
            rows_factory_names.append(factory_names_str)

        # مرتب‌سازی بر اساس مبلغ بدهی (نزولی)

        try:
            combined_list = list(
                zip(
                    rows_full_name,
                    rows_national_id,
                    rows_personnel_code,
                    rows_phone,
                    rows_total_debt_raw,
                    rows_total_factory_qty,
                    rows_total_free_qty,
                    rows_total_guest_qty,
                    rows_total_debt_formatted,
                    rows_center_of_charge,
                    Position_Job_history,
                    Place_of_service_recruitment_order,
                    rows_factory_names,
                    *[restaurant_columns[restaurant.id] for restaurant in restaurants],
                )
            )

            combined_list.sort(
                key=lambda x: x[4], reverse=True
            )  # بر اساس total_debt_raw

            # جدا کردن دوباره بعد از سورت
            sorted_data = list(zip(*combined_list))

            # ستون‌های اصلی
            rows_full_name = sorted_data[0]
            rows_national_id = sorted_data[1]
            rows_personnel_code = sorted_data[2]
            rows_phone = sorted_data[3]
            rows_total_debt_raw = sorted_data[4]
            rows_total_factory_qty = sorted_data[5]
            rows_total_free_qty = sorted_data[6]
            rows_total_guest_qty = sorted_data[7]
            rows_total_debt_formatted = sorted_data[8]
            rows_center_of_charge = sorted_data[9]
            Position_Job_history = sorted_data[10]
            Place_of_service_recruitment_order = sorted_data[11]
            rows_factory_names = sorted_data[12]

            restaurant_sorted_columns = {}
            for i, restaurant in enumerate(restaurants, start=13):
                restaurant_sorted_columns[restaurant.id] = sorted_data[i]

            # ستون‌های نهایی
            data_columns = [
                ("نام و نام خانوادگی", list(rows_full_name)),
                ("کد ملی", list(rows_national_id)),
                ("کد پرسنلی", list(rows_personnel_code)),
                ("شماره تماس", list(rows_phone)),
                ("تعداد سفارشات سهمیه ای", rows_total_factory_qty),
                ("تعداد سفارشات آزاد", rows_total_free_qty),
                ("تعداد سفارشات مهمان", rows_total_guest_qty),
                ("مبلغ بدهی", list(rows_total_debt_formatted)),
                ("مرکز هزینه", list(rows_center_of_charge)),
                ("سمت سوابق شغلی", list(Position_Job_history)),
                ("محل خدمت حکم کارگزین", list(Place_of_service_recruitment_order)),
                ("کارخانه‌های دارای رزرو", list(rows_factory_names)),
            ]

            for restaurant in restaurants:
                column_name = f"{restaurant.name} (تعداد سفارش)"
                data_columns.append(
                    (column_name, list(restaurant_sorted_columns[restaurant.id]))
                )

            # اضافه کردن یک ردیف خلاصه برای کل سفارشات هر رستوران
            summary_row = []
            for restaurant in restaurants:
                summary_row.append(restaurant_stats[restaurant.id]["total_orders"])

            # نام فایل و عنوان گزارش
            today_jalali = jdatetime.date.today().strftime("%Y/%m/%d")
            filename = f"Bedehi_Kol_Self_{today_jalali.replace('/', '-')}"
            report_title = f"گزارش کامل بدهی پرسنل به سلف - تولید شده در {today_jalali}"

            return export_to_excel(
                columns=data_columns,
                filename=filename,
                report_title=report_title,
                restaurant_stats=restaurant_stats,
                summary_row=summary_row,
                summary_start_col=13,
            )
        except Exception as e:
            messages.error(request, f"در این بازه زمانی اطلاعاتی در دسترس نیست!!! {e}")
            return redirect("users:managements_reports_dashboard")

    elif request.GET.get("export") == "single" and request.GET.get("employee_id"):
        start_date = request.GET.get("start_date")
        end_date = request.GET.get("end_date")

        # print(f"{}")

        jalali_str = start_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        strt_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        jalali_str = end_date.replace("-", "/").strip()
        y, m, d = map(int, jalali_str.split("/"))
        end_gregorian_date = gregorian_date = jdatetime.date(y, m, d).togregorian()

        employee_id = request.GET.get("employee_id")
        try:
            employee = Employee.objects.get(id=employee_id)
        except Employee.DoesNotExist:
            messages.error(request, "کارمند یافت نشد.")
            return redirect(request.path)

        # گرفتن تمام رزروهای تحویل‌شده و لغو نشده
        reservations = (
            FoodReservation.objects.filter(
                employee=employee,
                reservation_date__gte=strt_gregorian_date,
                reservation_date__lte=end_gregorian_date,
                is_canceled=0,
            )
            .select_related("menu_item__food", "menu_item__weekly_menu__restaurant")
            .order_by("-reservation_date")
        )

        # ساخت داده‌های اکسل
        col_names = [
            "تاریخ رزرو",
            "روز هفته",
            "رستوران",
            "غذا",
            "تعداد کارخانه",
            "تعداد آزاد",
            "تعداد مهمان",
            "هزینه کل سفارش (ریال)",
        ]

        rows_date = []
        rows_day = []
        rows_restaurant = []
        rows_food = []
        rows_factory_qty = []
        rows_free_qty = []
        rows_guest_qty = []
        rows_total_price = []
        reserver = []

        total_debt = 0

        for res in reservations:
            jalali_date = jdatetime.date.fromgregorian(date=res.reservation_date)
            day_name = jalali_date.strftime("%A")  # شنبه، یکشنبه و...

            if str(res.reserved_by) != "0":
                employee_reserver = Employee.objects.filter(
                    id=int(res.reserved_by)
                ).first()
                if employee_reserver:
                    reserver_name = employee_reserver.full_name
                else:
                    reserver_name = "ناشناس"
            else:
                reserver_name = (
                    Employee.objects.filter(id=res.employee_id).first().full_name
                )

            rows_date.append(jalali_date.strftime("%Y/%m/%d"))
            rows_day.append(day_name)
            rows_restaurant.append(res.menu_item.weekly_menu.restaurant.name)
            rows_food.append(res.menu_item.food.name)
            rows_factory_qty.append(res.factory_quantity)
            rows_free_qty.append(res.free_quantity)
            rows_guest_qty.append(res.guest_quantity)
            rows_total_price.append(res.total_price)
            reserver.append(reserver_name)

            total_debt += res.total_price

        # ستون‌ها
        data_columns = [
            ("تاریخ رزرو", rows_date),
            ("روز هفته", rows_day),
            ("رستوران", rows_restaurant),
            ("غذا", rows_food),
            ("تعداد سهمیه", rows_factory_qty),
            ("تعداد آزاد", rows_free_qty),
            ("تعداد مهمان", rows_guest_qty),
            ("هزینه کل سفارش (ریال)", rows_total_price),
            ("رزرو کننده", reserver),
        ]

        today = jdatetime.date.today().strftime("%Y-%m-%d")
        filename = f"Bedehi_{employee.full_name.replace(' ', '_')}_{today}"
        print()
        report_title = f"گزارش کامل رزروهای غذا - {employee.full_name} (کد ملی: {employee.national_id}) - مجموع بدهی: {total_debt:,} ریال"

        return export_to_excel(
            columns=data_columns, filename=filename, report_title=report_title
        )

    factories = Factory.objects.all()

    context = {
        "total_employees": total_employees,
        "total_restaurants": total_restaurants,
        "today_reservations": today_reservations,
        "factories": factories,
    }
    return render(request, "users/managements_reports_dashboard.html", context)


# @login_required
# def personal_reports_dashboard(request):
#     user = request.user
#     context = {
#         "user": user,
#     }
#     return render(request, "users/personal_reports_dashboard.html", context)


@login_required
def personal_reports_dashboard(request):
    user = request.user

    # # فقط کاربرانی که مجوز گزارش‌گیری دارند (reporting_permision=1) اجازه دسترسی دارند
    # if user.reporting_permision == 0:
    #     messages.error(request, "شما دسترسی به صفحه گزارش‌گیری شخصی ندارید.")
    #     return redirect("users:dashboard")

    # بازه تاریخ را از GET دریافت کن، در غیر این‌صورت ۳۰ روز اخیر را پیش‌فرض بگذار
    start_date_str = request.GET.get("start_date")
    end_date_str = request.GET.get("end_date")

    today_jalali = jdatetime.date.today()
    if not start_date_str or not end_date_str:
        end_date_jalali = today_jalali
        start_date_jalali = today_jalali - timedelta(days=30)
        start_date_str = start_date_jalali.strftime("%Y/%m/%d")
        end_date_str = end_date_jalali.strftime("%Y/%m/%d")
    else:
        # تبدیل فرمت‌های احتمالی (- به /) برای جلوگیری از خطا
        start_date_str = start_date_str.replace("-", "/")
        end_date_str = end_date_str.replace("-", "/")

    # تابع کمکی برای تبدیل تاریخ شمسی به میلادی
    def jalali_to_gregorian(date_str):
        date_str = date_str.strip()
        y, m, d = map(int, date_str.split("/"))
        return jdatetime.date(y, m, d).togregorian()

    try:
        start_greg = jalali_to_gregorian(start_date_str)
        end_greg = jalali_to_gregorian(end_date_str)
    except Exception:
        messages.error(request, "فرمت تاریخ نامعتبر است.")
        return redirect(request.path)

    # ----------------- دانلود گزارش اکسل (export=single) -----------------
    if request.GET.get("export") == "single":
        reservations = (
            FoodReservation.objects.filter(
                employee=user,
                reservation_date__gte=start_greg,
                reservation_date__lte=end_greg,
                is_canceled=0,
            )
            .select_related("menu_item__food", "menu_item__weekly_menu__restaurant")
            .order_by("-reservation_date")
        )

        # ساخت ستون‌های اکسل (مشابه نمونه قبلی)
        rows_date, rows_day, rows_restaurant, rows_food = [], [], [], []
        rows_factory, rows_free, rows_guest, rows_price = [], [], [], []
        total_debt = 0

        for res in reservations:
            jdate_obj = jdatetime.date.fromgregorian(date=res.reservation_date)
            rows_date.append(jdate_obj.strftime("%Y/%m/%d"))
            rows_day.append(jdate_obj.strftime("%A"))  # روز هفته فارسی
            rows_restaurant.append(res.menu_item.weekly_menu.restaurant.name)
            rows_food.append(res.menu_item.food.name)
            rows_factory.append(res.factory_quantity)
            rows_free.append(res.free_quantity)
            rows_guest.append(res.guest_quantity)
            rows_price.append(res.total_price)
            total_debt += res.total_price

        data_columns = [
            ("تاریخ رزرو", rows_date),
            ("روز هفته", rows_day),
            ("رستوران", rows_restaurant),
            ("غذا", rows_food),
            ("تعداد سهمیه", rows_factory),
            ("تعداد آزاد", rows_free),
            ("تعداد مهمان", rows_guest),
            ("هزینه کل سفارش (ریال)", rows_price),
        ]

        filename = f"Gozaresh_{user.full_name.replace(' ', '_')}_{today_jalali.strftime('%Y%m%d')}"
        report_title = (
            f"گزارش رزروهای {user.full_name} - مجموع بدهی: {total_debt:,} ریال"
        )

        return export_to_excel(
            columns=data_columns, filename=filename, report_title=report_title
        )

    # ----------------- داده‌های نمودار و کارت‌ها -----------------
    # جمع‌آوری رزروها در بازه برای کاربر جاری
    daily_stats = (
        FoodReservation.objects.filter(
            employee=user,
            reservation_date__gte=start_greg,
            reservation_date__lte=end_greg,
            is_canceled=0,
        )
        .values("reservation_date")
        .annotate(
            total_orders=Count("id"),
            total_price=Sum("total_price"),
            total_qty=Sum("factory_quantity")
            + Sum("free_quantity")
            + Sum("guest_quantity"),
        )
        .order_by("reservation_date")
    )

    # تبدیل به لیست‌های مورد نیاز Chart.js
    labels = []
    orders_data = []
    price_data = []
    qty_data = []

    for day in daily_stats:
        greg_date = day["reservation_date"]
        j_date = jdatetime.date.fromgregorian(date=greg_date)
        labels.append(j_date.strftime("%Y/%m/%d"))
        orders_data.append(day["total_orders"])
        price_data.append(int(day["total_price"] or 0))
        qty_data.append(int(day["total_qty"] or 0))

    # محاسبه آمار کلی برای کارت‌ها
    total_reservations = sum(orders_data)
    total_debt = sum(price_data)
    num_days = len(labels) if labels else 1
    avg_per_day = round(total_reservations / num_days)

    context = {
        "start_date": start_date_str,
        "end_date": end_date_str,
        "labels": labels,
        "orders_data": orders_data,
        "price_data": price_data,
        "qty_data": qty_data,
        "total_reservations": total_reservations,
        "total_debt": total_debt,
        "avg_per_day": avg_per_day,
    }

    print(f"context : {context}")

    return render(request, "users/personal_reports_dashboard.html", context)


@login_required
def export_restaurant_report(request):
    """گزارش روزانه رستوران‌ها به صورت ماتریسی"""
    start_date = request.GET.get("start_date")
    end_date = request.GET.get("end_date")

    if not start_date or not end_date:
        return HttpResponseBadRequest("لطفاً بازه تاریخ را انتخاب کنید")

    try:
        # تبدیل تاریخ‌ها
        y, m, d = map(int, start_date.split("/"))
        strt_gregorian = jdatetime.date(y, m, d).togregorian()
        y, m, d = map(int, end_date.split("/"))
        end_gregorian = jdatetime.date(y, m, d).togregorian()
    except:
        return HttpResponseBadRequest("فرمت تاریخ نامعتبر است")

    factory_id = request.session.get("current_factory_id")

    # دریافت سفارشات گروه‌بندی شده
    reservations = (
        FoodReservation.objects.filter(
            reservation_date__gte=strt_gregorian,
            reservation_date__lte=end_gregorian,
            is_canceled=0,
            related_factory_id=factory_id,
            menu_item__weekly_menu__restaurant__is_restaurant=True,
        )
        .values("reservation_date", "menu_item__weekly_menu__restaurant__name")
        .annotate(
            total_orders=Sum("factory_quantity")
            + Sum("free_quantity")
            + Sum("guest_quantity")
        )
        .order_by("reservation_date")
    )

    # ساخت دیکشنری داده‌ها
    from collections import defaultdict

    daily_stats = defaultdict(dict)

    for r in reservations:
        restaurant_name = r["menu_item__weekly_menu__restaurant__name"]
        orders = r["total_orders"] or 0
        daily_stats[r["reservation_date"]][restaurant_name] = orders

    # لیست رستوران‌ها
    restaurants = list(
        Subdepartment.objects.filter(
            is_restaurant=True, department__factory_id=factory_id
        ).values_list("name", flat=True)
    )

    dates = sorted(daily_stats.keys())

    if not dates:
        return HttpResponseBadRequest("در این بازه زمانی اطلاعاتی وجود ندارد")

    # ساخت ستون‌ها برای اکسل
    date_column = []
    for d in dates:
        jalali_date = jdatetime.date.fromgregorian(date=d).strftime("%Y/%m/%d")
        date_column.append(jalali_date)

    data_columns = [("تاریخ", date_column)]

    for restaurant in restaurants:
        restaurant_column = []
        for d in dates:
            restaurant_column.append(daily_stats[d].get(restaurant, 0))
        data_columns.append((restaurant, restaurant_column))

    # اضافه کردن ستون جمع روزانه
    daily_totals = []
    for d in dates:
        daily_total = sum(daily_stats[d].get(r, 0) for r in restaurants)
        daily_totals.append(daily_total)
    data_columns.append(("جمع روزانه", daily_totals))

    # عنوان گزارش
    today_jalali = jdatetime.date.today().strftime("%Y/%m/%d")
    report_title = f"گزارش عملکرد روزانه رستوران‌ها\nبازه: {start_date} تا {end_date}"
    filename = f"restaurant_report_{today_jalali.replace('/', '-')}"

    return export_to_excel(
        columns=data_columns, filename=filename, report_title=report_title
    )


@login_required
def export_detailed_employee_report(request):
    """گزارش کامل و دقیق یک کارمند با تمام جزئیات"""
    start_date = request.GET.get("start_date")
    end_date = request.GET.get("end_date")
    employee_id = request.GET.get("employee_id")

    if not start_date or not end_date or not employee_id:
        return HttpResponseBadRequest("پارامترهای لازم وارد نشده است")

    try:
        # تبدیل تاریخ‌ها
        y, m, d = map(int, start_date.split("/"))
        strt_gregorian = jdatetime.date(y, m, d).togregorian()
        y, m, d = map(int, end_date.split("/"))
        end_gregorian = jdatetime.date(y, m, d).togregorian()
    except:
        return HttpResponseBadRequest("فرمت تاریخ نامعتبر است")

    try:
        employee = Employee.objects.get(id=employee_id)
    except Employee.DoesNotExist:
        return HttpResponseBadRequest("کارمند یافت نشد")

    # دریافت رزروهای کارمند
    reservations = (
        FoodReservation.objects.filter(
            employee=employee,
            reservation_date__gte=strt_gregorian,
            reservation_date__lte=end_gregorian,
            is_canceled=0,
        )
        .select_related("menu_item__food", "menu_item__weekly_menu__restaurant")
        .order_by("-reservation_date")
    )

    if not reservations.exists():
        return HttpResponseBadRequest(
            f"هیچ رزروی برای {employee.full_name} در بازه انتخابی یافت نشد"
        )

    # آماده‌سازی داده‌ها
    rows_date = []
    rows_day = []
    rows_restaurant = []
    rows_food = []
    rows_factory_qty = []
    rows_free_qty = []
    rows_guest_qty = []
    rows_total_price = []
    rows_reserver = []

    total_debt = 0

    for res in reservations:
        jalali_date = jdatetime.date.fromgregorian(date=res.reservation_date)
        day_name = jalali_date.strftime("%A")

        # پیدا کردن رزرو کننده
        reserver_name = employee.full_name
        if res.reserved_by and res.reserved_by != "0":
            try:
                reserver = Employee.objects.get(id=int(res.reserved_by))
                reserver_name = reserver.full_name
            except (ValueError, Employee.DoesNotExist):
                reserver_name = "سیستم"

        rows_date.append(jalali_date.strftime("%Y/%m/%d"))
        rows_day.append(day_name)
        rows_restaurant.append(res.menu_item.weekly_menu.restaurant.name)
        rows_food.append(res.menu_item.food.name)
        rows_factory_qty.append(res.factory_quantity)
        rows_free_qty.append(res.free_quantity)
        rows_guest_qty.append(res.guest_quantity)
        rows_total_price.append(res.total_price)
        rows_reserver.append(reserver_name)

        total_debt += res.total_price

    # ساخت ستون‌ها برای اکسل
    data_columns = [
        ("تاریخ رزرو", rows_date),
        ("روز هفته", rows_day),
        ("رستوران", rows_restaurant),
        ("غذا", rows_food),
        ("تعداد سهمیه", rows_factory_qty),
        ("تعداد آزاد", rows_free_qty),
        ("تعداد مهمان", rows_guest_qty),
        ("هزینه کل (ریال)", rows_total_price),
        ("رزرو کننده", rows_reserver),
    ]

    # محاسبه آمار
    total_orders = len(reservations)
    total_factory = sum(rows_factory_qty)
    total_free = sum(rows_free_qty)
    total_guest = sum(rows_guest_qty)

    report_title = (
        f"گزارش کامل رزروهای غذا\n"
        f"کارمند: {employee.full_name} (کد ملی: {employee.national_id} | کد پرسنلی: {employee.personnel_code or 'ندارد'})\n"
        f"بازه: {start_date} تا {end_date}\n"
        f"آمار: {total_orders} سفارش | "
        f"سهمیه: {total_factory} | آزاد: {total_free} | مهمان: {total_guest}\n"
        f"جمع کل بدهی: {total_debt:,} ریال"
    )

    today_jalali = jdatetime.date.today().strftime("%Y%m%d")
    filename = (
        f"employee_{employee.personnel_code or employee.national_id}_{today_jalali}"
    )

    return export_to_excel(
        columns=data_columns, filename=filename, report_title=report_title
    )


@login_required
def export_employee_summary_report(request):
    """گزارش خلاصه یک کارمند (فقط آمار کلی)"""
    start_date = request.GET.get("start_date")
    end_date = request.GET.get("end_date")
    employee_id = request.GET.get("employee_id")

    if not start_date or not end_date or not employee_id:
        return HttpResponseBadRequest("پارامترهای لازم وارد نشده است")

    try:
        # تبدیل تاریخ‌ها
        y, m, d = map(int, start_date.split("/"))
        strt_gregorian = jdatetime.date(y, m, d).togregorian()
        y, m, d = map(int, end_date.split("/"))
        end_gregorian = jdatetime.date(y, m, d).togregorian()
    except:
        return HttpResponseBadRequest("فرمت تاریخ نامعتبر است")

    try:
        employee = Employee.objects.get(id=employee_id)
    except Employee.DoesNotExist:
        return HttpResponseBadRequest("کارمند یافت نشد")

    # دریافت رزروهای کارمند
    reservations = FoodReservation.objects.filter(
        employee=employee,
        reservation_date__gte=strt_gregorian,
        reservation_date__lte=end_gregorian,
        is_canceled=0,
    )

    if not reservations.exists():
        return HttpResponseBadRequest(
            f"هیچ رزروی برای {employee.full_name} در بازه انتخابی یافت نشد"
        )

    # محاسبه خلاصه آمار به تفکیک رستوران
    restaurant_stats = (
        reservations.values("menu_item__weekly_menu__restaurant__name")
        .annotate(
            total_orders=Sum("factory_quantity")
            + Sum("free_quantity")
            + Sum("guest_quantity"),
            total_cost=Sum("total_price"),
        )
        .order_by("-total_cost")
    )

    # آماده‌سازی داده‌ها
    rows_restaurant = []
    rows_total_orders = []
    rows_total_cost = []

    for stat in restaurant_stats:
        rows_restaurant.append(
            stat["menu_item__weekly_menu__restaurant__name"] or "نامشخص"
        )
        rows_total_orders.append(stat["total_orders"] or 0)
        rows_total_cost.append(f"{stat['total_cost'] or 0:,} ریال")

    # جمع کل
    total_orders = (
        reservations.aggregate(
            total=Sum("factory_quantity") + Sum("free_quantity") + Sum("guest_quantity")
        )["total"]
        or 0
    )

    total_factory = reservations.aggregate(total=Sum("factory_quantity"))["total"] or 0
    total_free = reservations.aggregate(total=Sum("free_quantity"))["total"] or 0
    total_guest = reservations.aggregate(total=Sum("guest_quantity"))["total"] or 0
    total_debt = reservations.aggregate(total=Sum("total_price"))["total"] or 0

    # ساخت ستون‌ها
    data_columns = [
        ("رستوران", rows_restaurant),
        ("تعداد کل سفارشات", rows_total_orders),
        ("هزینه کل (ریال)", rows_total_cost),
    ]

    report_title = (
        f"گزارش خلاصه رزروهای غذا - {employee.full_name}\n"
        f"کد ملی: {employee.national_id} | کد پرسنلی: {employee.personnel_code or 'ندارد'}\n"
        f"بازه: {start_date} تا {end_date}\n"
        f"آمار نهایی: {total_orders} سفارش | "
        f"سهمیه: {total_factory} | آزاد: {total_free} | مهمان: {total_guest}\n"
        f"مجموع بدهی: {total_debt:,} ریال"
    )

    today_jalali = jdatetime.date.today().strftime("%Y%m%d")
    filename = f"employee_summary_{employee.personnel_code or employee.national_id}_{today_jalali}"

    return export_to_excel(
        columns=data_columns, filename=filename, report_title=report_title
    )


@login_required
def restaurant_management_dashboard(request):
    # 1. دریافت اطلاعات نقش و جایگاه فعلی از سشن
    role_name = request.session.get("current_role")
    subdepartment_id = request.session.get("current_subdepartment_id")
    factory_id = request.session.get("current_factory_id")

    close_food_res_time_H = (
        Factory.objects.filter(id=factory_id).first().close_food_res_time_H
        if factory_id
        else 0
    )
    close_food_res_time_M = (
        Factory.objects.filter(id=factory_id).first().close_food_res_time_M
        if factory_id
        else 0
    )

    # 2. بررسی دسترسی
    if role_name != "supervisor" or not subdepartment_id:
        messages.error(request, "شما دسترسی به داشبورد مدیریت رستوران را ندارید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    restaurant = get_object_or_404(Subdepartment, id=subdepartment_id)

    if not restaurant.is_restaurant:
        messages.error(request, "زیربخش فعلی شما به عنوان رستوران تعریف نشده است.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    export_mode = request.GET.get("export")

    # Export by custom jalali date range from dashboard button
    if export_mode == "range":
        factory_name = (
            Factory.objects.filter(id=factory_id).first().name
            if factory_id
            else "unkwon_factory"
        )
        from_date_str = (request.GET.get("from_date") or "").strip()
        to_date_str = (request.GET.get("to_date") or "").strip()

        if not from_date_str or not to_date_str:
            messages.error(request, "تاریخ شروع و پایان را وارد کنید.")
            return redirect("users:restaurant_management_dashboard")

        try:
            from_jy, from_jm, from_jd = map(int, from_date_str.split("/"))
            to_jy, to_jm, to_jd = map(int, to_date_str.split("/"))
            from_gdate = jdatetime.date(from_jy, from_jm, from_jd).togregorian()
            to_gdate = jdatetime.date(to_jy, to_jm, to_jd).togregorian()
        except Exception:
            messages.error(request, "فرمت تاریخ نامعتبر است.")
            return redirect("users:restaurant_management_dashboard")

        if from_gdate > to_gdate:
            from_gdate, to_gdate = to_gdate, from_gdate
            from_date_str, to_date_str = to_date_str, from_date_str

        range_rows = (
            FoodReservation.objects.filter(
                menu_item__weekly_menu__restaurant=restaurant,
                reservation_date__range=(from_gdate, to_gdate),
                is_canceled=False,
            )
            .values(
                "reservation_date",
                "menu_item__food__name",
                "menu_item__food__free_price",
            )
            .annotate(
                quota_count=Sum("factory_quantity"),
                extra_count=Sum("free_quantity"),
                guest_count=Sum("guest_quantity"),
            )
            .order_by("reservation_date", "menu_item__food__name")
        )

        col_days, col_dates, col_foods = [], [], []
        col_quota, col_extra, col_guest, col_total, col_food_price, col_total_dept = (
            [],
            [],
            [],
            [],
            [],
            [],
        )

        for row in range_rows:
            gdate = row["reservation_date"]
            jdate = jdatetime.date.fromgregorian(date=gdate)
            quota_count = row.get("quota_count") or 0
            extra_count = row.get("extra_count") or 0
            guest_count = row.get("guest_count") or 0

            col_days.append(jdate.strftime("%A"))
            col_dates.append(jdate.strftime("%Y/%m/%d"))
            col_foods.append(row.get("menu_item__food__name") or "---")
            col_quota.append(quota_count)
            col_extra.append(extra_count)
            col_guest.append(guest_count)
            col_total.append(quota_count + extra_count + guest_count)
            col_food_price.append((row.get("menu_item__food__free_price")))
            col_total_dept.append(
                (quota_count + extra_count + guest_count)
                * (int(row.get("menu_item__food__free_price")))
            )

        data_columns = [
            ("روز هفته", col_days),
            ("تاریخ", col_dates),
            ("نام غذا", col_foods),
            ("تعداد سهمیه (پرسنلی)", col_quota),
            ("تعداد آزاد", col_extra),
            ("تعداد مهمان", col_guest),
            ("مجموع کل", col_total),
            ("هزینه هر پرس", col_food_price),
            ("هزینه کل", col_total_dept),
        ]

        filename = f"گزارش_کارخانه_{factory_name}_در بازه زمانی_{from_date_str.replace('/', '-')}_تا_{to_date_str.replace('/', '-')}"

        # نسخه امن برای هدر
        encoded_filename = quote(filename)

        report_title = f"گزارش رزرو غذا - {restaurant.name} - بازه {from_date_str} تا {to_date_str}"
        return export_to_excel(
            columns=data_columns, filename=encoded_filename, report_title=report_title
        )

    today_gdate = date.today()
    today_jdate = jdatetime.date.today()
    days_until_saturday = today_jdate.weekday()
    week_start_jdate = today_jdate - timedelta(days=days_until_saturday)
    current_week_start = week_start_jdate.togregorian()

    week_end_jdate = week_start_jdate + timedelta(days=6)
    current_week_end = week_end_jdate.togregorian()

    # current_week_start = today_gdate - timedelta(days=(today_gdate.weekday() + 1) % 7)

    # print(week_start_date)

    # 3. پیدا کردن آخرین منوی هفتگی فعال
    latest_menu = (
        WeeklyMenu.objects.filter(
            restaurant=restaurant, week_start_date__lte=today_gdate
        )
        .order_by("-week_start_date")
        .first()
    )

    menu_start_date = current_week_start

    weekly_report_data = []
    latest_menu_info = "هیچ منوی فعالی یافت نشد."

    if latest_menu:
        latest_menu_info = f"اخرین تاریخ تغییر منو {jdatetime.date.fromgregorian(date=latest_menu.week_start_date).strftime('%Y/%m/%d')}"

        # لیست کدهای روزهای هفته (برای دیتابیس)
        week_days_codes = [
            "shanbe",
            "1shanbe",
            "2shanbe",
            "3shanbe",
            "4shanbe",
            "5shanbe",
            "jome",
        ]

        # 🌟 لیست نام‌های فارسی روزهای هفته (برای نمایش) 🌟
        persian_day_names = [
            "شنبه",
            "یکشنبه",
            "دوشنبه",
            "سه‌شنبه",
            "چهارشنبه",
            "پنج‌شنبه",
            "جمعه",
        ]

        # تاریخ شروع منو (که همیشه شنبه است)
        # menu_start_date = latest_menu.week_start_date
        menu_items = MenuItem.objects.filter(weekly_menu=latest_menu).select_related(
            "food"
        )

        # 4. حلقه روی تمام 7 روز هفته (بدون توجه به اینکه گذشته یا آینده است)
        for i, day_code in enumerate(week_days_codes):

            print(day_code)
            current_day_date = menu_start_date + timedelta(days=i)

            # تبدیل به تاریخ شمسی
            j_date = jdatetime.date.fromgregorian(date=current_day_date)
            jdate_str = f"{persian_day_names[i]} {j_date.strftime('%Y/%m/%d')}"
            day_menu_items = menu_items.filter(day_persian=day_code)

            foods_data = []
            if day_menu_items.exists():
                for item in day_menu_items:
                    reservations = FoodReservation.objects.filter(
                        menu_item=item,
                        reservation_date=current_day_date,
                        is_canceled=False,
                    )
                    factory_quantity = (
                        reservations.aggregate(total=Sum("factory_quantity"))["total"]
                        or 0
                    )
                    free_quantity = (
                        reservations.aggregate(total=Sum("free_quantity"))["total"] or 0
                    )
                    guest_quantity = (
                        reservations.aggregate(total=Sum("guest_quantity"))["total"]
                        or 0
                    )
                    total_count = factory_quantity + free_quantity + guest_quantity
                    foods_data.append(
                        {
                            "food_name": item.food.name,
                            "quota_count": factory_quantity,
                            "extra_count": free_quantity,
                            "guest_count": guest_quantity,
                            "total_count": total_count,
                        }
                    )

            is_reservation_time = False
            if current_day_date == today_gdate:

                tehran_aware_datetime = timezone.localtime(timezone.now())
                is_reservation_time = tehran_aware_datetime.time() < time(
                    close_food_res_time_H, close_food_res_time_M
                )
            elif current_day_date > today_gdate:

                is_reservation_time = True

            weekly_report_data.append(
                {
                    "date_obj": current_day_date,
                    "jdate_str": jdate_str,
                    "jdate_only": j_date.strftime("%Y/%m/%d"),
                    "is_today": current_day_date == today_gdate,
                    "foods": foods_data,
                    "is_reservation_time": is_reservation_time,
                    "persian_day_names": persian_day_names[i],
                }
            )

    export_date_str = request.GET.get("export_date") or request.GET.get("date")
    if export_date_str:
        try:
            jy, jm, jd = map(int, export_date_str.split("/"))
            export_gdate = jdatetime.date(jy, jm, jd).togregorian()
            # فیلتر فقط اون روز
            weekly_report_data = [
                day for day in weekly_report_data if day["date_obj"] == export_gdate
            ]
        except:
            pass  # اگر تاریخ اشتباه بود، کل هفته رو نگه دار

    # --- حالا چک می‌کنیم آیا باید اکسل بده یا نه ---
    if request.GET.get("export") == "excel" or export_date_str:
        # آماده‌سازی داده‌ها برای اکسل
        col_dates, col_days, col_foods = [], [], []
        col_quota, col_extra, col_total = [], [], []

        for day_data in weekly_report_data:
            day_name_part = day_data["jdate_str"].split(" ")[0]
            date_part = day_data["jdate_str"].split(" ")[1]

            if day_data["foods"]:
                for food in day_data["foods"]:
                    col_days.append(day_name_part)
                    col_dates.append(date_part)
                    col_foods.append(food["food_name"])
                    col_quota.append(food["quota_count"])
                    col_extra.append(food["extra_count"])
                    col_total.append(food["total_count"])
            else:
                col_days.append(day_name_part)
                col_dates.append(date_part)
                col_foods.append("---")
                col_quota.append(0)
                col_extra.append(0)
                col_total.append(0)

        data_columns = [
            ("روز هفته", col_days),
            ("تاریخ", col_dates),
            ("نام غذا", col_foods),
            ("تعداد سهمیه (پرسنلی)", col_quota),
            ("تعداد آزاد", col_extra),
            ("مجموع کل", col_total),
        ]

        # تنظیم اسم فایل و عنوان
        if len(weekly_report_data) == 1:
            the_day_str = weekly_report_data[0]["jdate_str"]
            filename = (
                f"Gozaresh_Restaurant_{the_day_str.replace(' ', '_').replace('/', '-')}"
            )
            report_title = f"گزارش رزرو غذا - {the_day_str} - {restaurant.name}"
        else:
            today_str = jdatetime.date.today().strftime("%Y-%m-%d")
            filename = f"Gozaresh_Restaurant_{today_str}"
            report_title = (
                f"گزارش عملکرد رستوران {restaurant.name} - {latest_menu_info}"
            )

        return export_to_excel(
            columns=data_columns, filename=filename, report_title=report_title
        )

    # page_expires_at = timezone.now() + timedelta(minutes=10)
    expire_seconds = 60

    context = {
        "restaurant_name": restaurant.name,
        "latest_menu_info": latest_menu_info,
        "weekly_data": weekly_report_data,
        "close_food_res_time_H": close_food_res_time_H,
        "close_food_res_time_M": close_food_res_time_M,
        "expire_seconds": expire_seconds,
    }

    return render(request, "users/restaurant_management_dashboard.html", context)


PERSIAN_WEEK_DAYS = [
    ("shanbe", "شنبه"),
    ("1shanbe", "یکشنبه"),
    ("2shanbe", "دوشنبه"),
    ("3shanbe", "سه‌شنبه"),
    ("4shanbe", "چهارشنبه"),
    ("5shanbe", "پنج‌شنبه"),
    ("jome", "جمعه"),
]


@transaction.atomic
@login_required
def food_reservation_view(request):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    is_committee = request.session["current_is_committee"]
    can_choose_factory = False
    available_factories = Factory.objects.none()
    user = request.user
    factory = None

    max_factory_quantity = user.factory_limit_reservation
    max_free_quantity = user.free_limit_reservation
    max_guest_quantity = user.guest_limit_reservation

    # today_gdate = date.today() - timedelta(days=3)
    # today_jdate = jdatetime.date.today() - timedelta(days=3)
    # today_gdate = date.today() + timedelta(days=2)
    # today_jdate = jdatetime.date.today() + timedelta(days=2)
    today_gdate = date.today()
    today_jdate = jdatetime.date.today()

    weeks_count = int(getattr(settings, "WEEKS_COUNT", 1) or 1)

    # weeks_count = settings.WEEKS_COUNT

    # if not user.unlimit_reservation:
    #     max_factory_quantity = user.factory_limit_reservation
    #     max_free_quantity = user.free_limit_reservation
    #     max_guest_quantity = user.guest_limit_reservation
    # else:
    #     max_factory_quantity = 1
    #     max_free_quantity = 100
    #     max_guest_quantity = 100

    if "form_token" not in request.session:
        request.session["form_token"] = get_random_string(32)

    can_reserve_management_food = user.can_reserve_management_food

    form_token = request.session["form_token"]

    can_choose_factory = False
    can_reserve_guest = False

    extra_available_factories_for_food_reservation = (
        user.extra_available_factories_for_food_reservation.all()
    )

    if (
        role_name
        in ["super_admin", "holding_manager", "factory_manager", "department_manager"]
        or user.unlimit_reservation
        or user.guest_limit_reservation > 0
    ):
        can_reserve_guest = True

    if (
        role_name in ["holding_manager", "super_admin"]
        or extra_available_factories_for_food_reservation.exists()
    ):
        can_choose_factory = True

        target_factory_id = request.GET.get("target_factory_id") or request.POST.get(
            "target_factory_id"
        )

        if role_name == "super_admin":
            available_factories = Factory.objects.all()
        elif role_name == "holding_manager":
            available_factories = Factory.objects.filter(holding_id=holding_id).all()

        if is_committee:
            factory = Factory.objects.filter(id=factory_id).first().linked_factory
        else:
            factory = Factory.objects.filter(id=factory_id).first()

        if factory:
            available_factories = available_factories | Factory.objects.filter(
                pk=factory.pk
            )

        if extra_available_factories_for_food_reservation.exists():
            available_factories = (
                available_factories | extra_available_factories_for_food_reservation
            )

        available_factories = available_factories.distinct()

        if target_factory_id:
            try:
                selected_factory = Factory.objects.filter(id=target_factory_id).first()
                if selected_factory:
                    factory = selected_factory
                    request.session["food_target_factory_id"] = selected_factory.id
                else:
                    messages.error(request, "کارخانه انتخاب‌شده معتبر نیست.")
            except (ValueError, TypeError):
                messages.error(request, "شناسه کارخانه نامعتبر است.")
        elif request.session.get("food_target_factory_id") != None:
            # اگر هیچ target_factory_id نبود، از سشن قبلی استفاده کن
            session_factory_id = request.session.get("food_target_factory_id")
            if session_factory_id:
                selected_factory = available_factories.filter(
                    id=session_factory_id
                ).first()
                if selected_factory:
                    factory = selected_factory
        else:
            if role_name == "super_admin":
                factory = Factory.objects.first()
            elif role_name == "holding_manager":
                factory = Factory.objects.filter(holding_id=holding_id).first()
            else:
                factory = Factory.objects.filter(id=factory_id).first()

    else:
        if is_committee:
            factory = Factory.objects.filter(id=factory_id).first().linked_factory
        else:
            factory = Factory.objects.filter(id=factory_id).first()

    if not factory:
        messages.warning(
            request, "کارخانه شما مشخص نشده است. لطفا با بخش هوش مصنوعی تماس بگیرید."
        )
        # return redirect("users:dashboard")
        return redirect("users:landing")

    close_food_res_time_H = (
        factory.close_food_res_time_H
        if (
            factory.close_food_res_time_H
            and factory.close_food_res_time_H >= 0
            and factory.close_food_res_time_H < 24
        )
        else default_close_food_res_time_H
    )
    close_food_res_time_M = (
        factory.close_food_res_time_M
        if (
            factory.close_food_res_time_M
            and factory.close_food_res_time_M >= 0
            and factory.close_food_res_time_M < 60
        )
        else default_close_food_res_time_M
    )
    # print(f"********** {close_food_res_time_H}")

    days_until_saturday = today_jdate.weekday()
    base_week_start_jdate = today_jdate - timedelta(days=days_until_saturday)

    week_starts_jdate = [
        base_week_start_jdate + timedelta(days=7 * i) for i in range(weeks_count)
    ]
    full_start_date = week_starts_jdate[0].togregorian()
    full_end_date = (week_starts_jdate[-1] + timedelta(days=6)).togregorian()

    existing_reservations = (
        FoodReservation.objects.filter(
            employee=user,
            reservation_date__gte=full_start_date,
            reservation_date__lte=full_end_date,
            related_factory=factory,
            is_canceled=False,
            menu_item__food__is_management_food=False,
        )
        .select_related(
            "menu_item__food", "menu_item__weekly_menu__restaurant__department"
        )
        .order_by("reserved_at")
        .all()
    )

    def get_weekly_menus_for_week(week_start_date):
        latest_start_dates = (
            WeeklyMenu.objects.filter(
                restaurant__department__factory=factory,
                week_start_date__lte=week_start_date,
            )
            .values("restaurant")
            .annotate(latest_start_date=Max("week_start_date"))
        )

        if not latest_start_dates.exists():
            return WeeklyMenu.objects.none()

        q_objects = Q()
        for item in latest_start_dates:
            q_objects |= Q(
                restaurant_id=item["restaurant"],
                week_start_date=item["latest_start_date"],
            )

        return (
            WeeklyMenu.objects.filter(q_objects)
            .select_related("restaurant", "restaurant__department")
            .all()
        )

    weekly_data = []
    week_days = [code for code, name in PERSIAN_WEEK_DAYS]

    for week_index, week_start_jdate in enumerate(week_starts_jdate, start=1):
        week_start_date = week_start_jdate.togregorian()
        week_end_date = week_start_date + timedelta(days=6)

        weekly_menus = get_weekly_menus_for_week(week_start_date)

        if weekly_menus:
            all_menu_items = (
                MenuItem.objects.filter(
                    weekly_menu__in=weekly_menus,
                    food__is_management_food=False,
                )
                .select_related("food", "weekly_menu__restaurant")
                .all()
            )
        else:
            all_menu_items = MenuItem.objects.none()

        for i, day_code in enumerate(week_days):
            day_date_j = week_start_jdate + jdatetime.timedelta(days=i)
            day_date_g = week_start_date + timedelta(days=i)
            day_name = dict(PERSIAN_WEEK_DAYS)[day_code]

            menus = all_menu_items.filter(day_persian=day_code)

            is_reservation_possible = day_date_g >= today_gdate

            tehran_aware_datetime = timezone.localtime(timezone.now())
            is_reservation_time_passed = False
            if day_date_g == today_gdate:
                is_reservation_time_passed = tehran_aware_datetime.time() > time(
                    close_food_res_time_H, close_food_res_time_M
                )

            is_today_comment_time = not is_reservation_possible or (
                day_date_g == today_gdate
                and tehran_aware_datetime.time()
                > time(start_today_food_comment_time_H, start_today_food_comment_time_M)
            )

            available_menu_ids = list(menus.values_list("id", flat=True))

            day_reservations = existing_reservations.filter(reservation_date=day_date_g)

            user_food_ids = day_reservations.values_list("menu_item__id", flat=True)

            users_feedbacks = (
                FoodReservation.objects.filter(
                    menu_item__id__in=user_food_ids,
                    menu_item__food__is_management_food=False,
                )
                .exclude(Q(feedback__isnull=True) & Q(rating__isnull=True))
                .select_related("menu_item__food", "employee")
            )

            day_food_feedbacks = {}

            for item in users_feedbacks:
                food_id = item.menu_item.id
                user_can_comment = True if item.employee != user else False

                if food_id not in day_food_feedbacks:
                    day_food_feedbacks[food_id] = {"comments": [], "ratings": []}

                if item.feedback:
                    day_food_feedbacks[food_id]["comments"].append(
                        {
                            "text": item.feedback,
                            "rating": item.rating,
                            "user": item.employee.full_name,
                            "date": item.reserved_at,
                            "user_can_comment": user_can_comment,
                        }
                    )

                if item.rating:
                    day_food_feedbacks[food_id]["ratings"].append(item.rating)

            weekly_data.append(
                {
                    "week_index": week_index,
                    "week_start_date": week_start_date,
                    "week_end_date": week_end_date,
                    "day_name": day_name,
                    "jdate_str": day_date_j.strftime("%Y/%m/%d"),
                    "gdate_str": day_date_g.strftime("%Y-%m-%d"),
                    "menus": menus,
                    "is_reservation_possible": is_reservation_possible,
                    "is_reservation_time_passed": is_reservation_time_passed,
                    "available_menu_ids": available_menu_ids,
                    "average_ratings": 3.5,
                    "user_can_comment": True,
                    "day_reservations": day_reservations,
                    "day_food_feedbacks": day_food_feedbacks,
                    "reservation_time_limit": time(
                        close_food_res_time_H, close_food_res_time_M
                    ),
                    "is_today_comment_time": is_today_comment_time,
                }
            )

    # week_start_jdate = today_jdate - timedelta(days=days_until_saturday)
    # week_start_date = (
    #     week_start_jdate.togregorian()
    # )  # تاریخ میلادی برای جستجوی WeeklyMenu

    # latest_start_dates = (
    #     WeeklyMenu.objects.filter(
    #         restaurant__department__factory=factory,
    #         week_start_date__lte=week_start_date,
    #     )
    #     .values("restaurant")
    #     .annotate(latest_start_date=Max("week_start_date"))
    # )

    # # 2. ساخت Q object برای فچ کردن منوهای دقیق (Greatest-N-per-Group)
    # q_objects = Q()
    # if latest_start_dates.exists():
    #     for item in latest_start_dates:
    #         # ترکیب شناسه رستوران و آخرین تاریخ شروع آن
    #         q_objects |= Q(
    #             restaurant_id=item["restaurant"],
    #             week_start_date=item["latest_start_date"],
    #         )

    #     # فچ کردن منوهای هفتگی که شرایط Q object را دارند
    #     weekly_menus = (
    #         WeeklyMenu.objects.filter(q_objects)
    #         .select_related("restaurant", "restaurant__department")
    #         .all()
    #     )
    # else:
    #     weekly_menus = WeeklyMenu.objects.none()

    # if weekly_menus:
    #     all_menu_items = (
    #         MenuItem.objects.filter(
    #             weekly_menu__in=weekly_menus, food__is_management_food=False
    #         )
    #         .select_related("food", "weekly_menu__restaurant")
    #         .all()
    #     )
    # else:
    #     all_menu_items = MenuItem.objects.none()

    # existing_reservations = (
    #     FoodReservation.objects.filter(
    #         employee=user,
    #         reservation_date__gte=week_start_date,
    #         reservation_date__lte=week_start_date + timedelta(days=6),
    #         related_factory=factory,
    #         is_canceled=False,
    #         menu_item__food__is_management_food=False,
    #     )
    #     .select_related(
    #         "menu_item__food", "menu_item__weekly_menu__restaurant__department"
    #     )
    #     .order_by("reserved_at")
    #     .all()
    # )

    # weekly_data = []
    # week_days = [code for code, name in PERSIAN_WEEK_DAYS]

    # for i, day_code in enumerate(week_days):
    #     day_date_j = week_start_jdate + jdatetime.timedelta(days=i)
    #     day_date_g = week_start_date + timedelta(days=i)
    #     day_name = dict(PERSIAN_WEEK_DAYS)[day_code]

    #     # لیست منوها برای این روز (هر ترکیب غذا + رستوران جداگانه)
    #     menus = all_menu_items.filter(day_persian=day_code)

    #     # امکان رزرو: آینده یا امروز قبل از ۱۰ صبح
    #     is_reservation_possible = day_date_g >= today_gdate

    #     tehran_aware_datetime = timezone.localtime(timezone.now())
    #     is_reservation_time_passed = False
    #     if day_date_g == today_gdate:
    #         is_reservation_time_passed = tehran_aware_datetime.time() > time(
    #             close_food_res_time_H, close_food_res_time_M
    #         )

    #     is_today_comment_time = (
    #         not is_reservation_possible
    #         or (day_date_g == today_gdate)
    #         and tehran_aware_datetime.time()
    #         > time(start_today_food_comment_time_H, start_today_food_comment_time_M)
    #     )

    #     # لیست IDهای منوهای موجود (برای چک رزروهای قدیمی)
    #     available_menu_ids = list(menus.values_list("id", flat=True))
    #     print(f"**************{available_menu_ids}")

    #     # رزروهای قبلی برای این روز
    #     day_reservations = existing_reservations.filter(reservation_date=day_date_g)

    #     user_food_ids = day_reservations.values_list("menu_item__id", flat=True)

    #     users_feedbacks = (
    #         FoodReservation.objects.filter(
    #             menu_item__id__in=user_food_ids,
    #             menu_item__food__is_management_food=False,
    #             # ).exclude(employee=user
    #         )
    #         .exclude(Q(feedback__isnull=True) & Q(rating__isnull=True))
    #         .select_related("menu_item__food", "employee")
    #     )

    #     # دیکشنری خروجی نهایی
    #     day_food_feedbacks = {}
    #     # print(users_feedbacks)

    #     for item in users_feedbacks:
    #         food_id = item.menu_item.id
    #         user_can_comment = True if item.employee != user else False

    #         # print(user_can_comment)

    #         if food_id not in day_food_feedbacks:
    #             day_food_feedbacks[food_id] = {"comments": [], "ratings": []}

    #         if item.feedback:
    #             day_food_feedbacks[food_id]["comments"].append(
    #                 {
    #                     "text": item.feedback,
    #                     "rating": item.rating,
    #                     "user": item.employee.full_name,
    #                     "date": item.reserved_at,
    #                     "user_can_comment": user_can_comment,
    #                 }
    #             )

    #         if item.rating:
    #             day_food_feedbacks[food_id]["ratings"].append((item.rating))

    #     day_previous_comments = []
    #     day_average_ratings = 3.5
    #     user_can_comment = True
    #     is_today_comment_time = True

    #     weekly_data.append(
    #         {
    #             "day_name": day_name,
    #             "jdate_str": day_date_j.strftime("%Y/%m/%d"),
    #             "gdate_str": day_date_g.strftime("%Y-%m-%d"),
    #             "menus": menus,
    #             "is_reservation_possible": is_reservation_possible,
    #             "is_reservation_time_passed": is_reservation_time_passed,
    #             "available_menu_ids": available_menu_ids,
    #             # 'previous_comments': day_previous_comments,
    #             "average_ratings": day_average_ratings,
    #             "user_can_comment": user_can_comment,
    #             "day_reservations": day_reservations,
    #             "day_food_feedbacks": day_food_feedbacks,
    #             "reservation_time_limit": time(
    #                 close_food_res_time_H, close_food_res_time_M
    #             ),
    #             "is_today_comment_time": is_today_comment_time,
    #         }
    #     )
    #     # print(weekly_data)

    if request.method == "POST" and "submit_reservations" in request.POST:

        post_token = request.POST.get("form_token")
        session_token = request.session.get("form_token")

        if not post_token or post_token != session_token:
            messages.error(request, "فرم معتبر نیست. لطفا مجددا تلاش کنید.")
            return redirect(request.path)

        # بعد از پردازش موفق، توکن جدید ایجاد کن
        request.session["form_token"] = get_random_string(32)

        is_reservation_time_passed = tehran_aware_datetime.time() > time(
            close_food_res_time_H, close_food_res_time_M
        )

        today = tehran_aware_datetime.date()

        parsed_reservations = []

        for key, value in request.POST.items():
            print("key : ", key, "value : ", value)
            if not key.startswith("reservations["):
                continue

            parts = key.split("][")

            date_str = parts[0].replace("reservations[", "")
            index = parts[1]
            field = parts[2].replace("]", "")

            if date_str not in [d["date"] for d in parsed_reservations]:
                pass  # handled below

            # یک دیکشنری پیدا کن (یا بساز)
            target_key = f"{date_str}-{index}"
            # print(f"aaaaaaaaa{parsed_reservations}")

            if target_key not in [r.get("key") for r in parsed_reservations]:
                parsed_reservations.append(
                    {
                        "key": target_key,
                        "date": date_str,
                        "food_choice": None,
                        "quantity": None,
                        "price_type": None,
                    }
                )

            # print(f"bbbbbbbbb{parsed_reservations}")

            # دیکشنری مربوطه را بگیر
            target = next(r for r in parsed_reservations if r["key"] == target_key)

            # حالا مقدار فیلد را ثبت کن
            if field == "food_choice":
                target["food_choice"] = int(value)
            elif field == "quantity":
                target["quantity"] = int(value)
            elif field == "price_type":
                target["price_type"] = value

        # حذف رکوردهای خالی یا food_choice=0
        parsed_reservations = [
            r
            for r in parsed_reservations
            if r["food_choice"] not in [None, 0] and r["quantity"] > 0
        ]

        if not is_reservation_time_passed:
            FoodReservation.objects.filter(
                employee=user,
                related_factory=factory,
                reservation_date__gte=today,
                menu_item__food__is_management_food=False,
            ).delete()
        else:
            FoodReservation.objects.filter(
                employee=user,
                related_factory=factory,
                reservation_date__gt=today,
                menu_item__food__is_management_food=False,
            ).delete()

        for item in parsed_reservations:

            date_g = datetime.strptime(item["date"], "%Y-%m-%d").date()

            menu_item = MenuItem.objects.filter(
                id=item["food_choice"], food__is_management_food=False
            ).first()
            if not menu_item:
                continue

            # نوع قیمت → انتخاب فیلدها
            fq = ffree = fg = 0
            if item["price_type"] == "factory":
                fq = item["quantity"]
                fq = fq if (fq <= max_factory_quantity) else max_factory_quantity
                unit_price = menu_item.food.factory_price
            elif item["price_type"] == "free":
                ffree = item["quantity"]
                ffree = ffree if (ffree <= max_free_quantity) else max_free_quantity
                unit_price = menu_item.food.free_price
            elif item["price_type"] == "guest":
                if can_reserve_guest:
                    fg = item["quantity"]
                    fg = fg if (fg <= max_guest_quantity) else max_guest_quantity
                    print(f"done{fg}")
                else:
                    print("0")
                    fg = 0
                unit_price = menu_item.food.guest_price

            # -----------------------------------------
            # 1) چک کن آیا رکورد موجود هست؟
            # -----------------------------------------
            existing = FoodReservation.objects.filter(
                employee=request.user,
                reservation_date=date_g,
                menu_item=menu_item,
                related_factory=factory,
                is_canceled=False,
                menu_item__food__is_management_food=False,
            ).first()

            if existing:
                # -----------------------------------------
                # 2) اگر هست → فقط مقدارها رو اضافه کن
                # -----------------------------------------
                existing.factory_quantity += fq
                existing.free_quantity += ffree
                existing.guest_quantity += fg

                existing.factory_quantity = (
                    existing.factory_quantity
                    if (existing.factory_quantity <= max_factory_quantity)
                    else max_factory_quantity
                )
                existing.free_quantity = (
                    existing.free_quantity
                    if (existing.free_quantity <= max_free_quantity)
                    else max_free_quantity
                )
                existing.guest_quantity = (
                    existing.guest_quantity
                    if (existing.guest_quantity <= max_guest_quantity)
                    else max_guest_quantity
                )

                # قیمت‌ها یک بار برای همیشه ثابت می‌مونن
                existing.factory_price = menu_item.food.factory_price
                existing.free_price = menu_item.food.free_price
                existing.guest_price = menu_item.food.guest_price

                # total_price باید مجموع همه‌ی قیمت‌ها بشه
                existing.total_price = (
                    existing.factory_quantity * existing.factory_price
                    + existing.free_quantity * existing.free_price
                    + existing.guest_quantity * existing.guest_price
                )

                existing.save()
                continue

            # -----------------------------------------
            # 3) اگر نبود → رکورد جدید بساز
            # -----------------------------------------
            FoodReservation.objects.create(
                employee=request.user,
                menu_item=menu_item,
                reservation_date=date_g,
                related_factory=factory,
                factory_quantity=fq,
                free_quantity=ffree,
                guest_quantity=fg,
                factory_price=menu_item.food.factory_price,
                free_price=menu_item.food.free_price,
                guest_price=menu_item.food.guest_price,
                total_price=(unit_price * item["quantity"]),
            )
        messages.success(request, "رزروهای شما با موفقیت ثبت شدند.")
        return redirect(request.path)

    elif request.method == "POST" and "submit_comment" in request.POST:
        # print("comment")
        # print(request.POST)
        comment_text = request.POST.get("comment_text")
        rating = request.POST.get("rating")
        menu_item_id = request.POST.get("menu_item_id")
        comment_date = request.POST.get("comment_date")

        # print(comment_text)
        # print(rating)
        # print(menu_item_id)
        # print(comment_date)

        existing = FoodReservation.objects.filter(
            employee=request.user,
            reservation_date=comment_date,
            menu_item__id=menu_item_id,
            related_factory=factory,
            menu_item__food__is_management_food=False,
        ).first()

        # آپدیت نظر و امتیاز
        existing.feedback = comment_text
        existing.rating = rating

        existing.save(update_fields=["feedback", "rating"])

    context = {
        "weekly_data": weekly_data,
        "week_start_date": week_start_date,
        "max_factory_quantity": max_factory_quantity,
        "max_free_quantity": max_free_quantity,
        "max_guest_quantity": max_guest_quantity,
        "can_reserve_guest": can_reserve_guest,
        "user_factory_name": factory.name,
        "can_choose_factory": can_choose_factory,
        "available_factories": available_factories,
        "selected_factory_id": factory.id,
        "current_factory_id": factory.id,
        "today_gdate_str": tehran_aware_datetime.date(),
        "is_reservation_time_passed": is_reservation_time_passed,
        "form_token": form_token,
        "can_reserve_management_food": can_reserve_management_food,
    }

    # print(f"context : {context}")

    return render(request, "users/food_reservation.html", context)


@transaction.atomic
@login_required
def management_food_reservation_view(request):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    is_committee = request.session["current_is_committee"]
    can_choose_factory = False
    available_factories = Factory.objects.none()
    user = request.user
    factory = None

    max_factory_quantity = user.factory_limit_reservation
    max_free_quantity = user.free_limit_reservation
    max_guest_quantity = user.guest_limit_reservation

    today_gdate = date.today()
    today_jdate = jdatetime.date.today()

    weeks_count = int(getattr(settings, "WEEKS_COUNT", 1) or 1)

    if "form_token" not in request.session:
        request.session["form_token"] = get_random_string(32)

    can_reserve_management_food = user.can_reserve_management_food

    form_token = request.session["form_token"]

    can_choose_factory = False
    can_reserve_guest = False

    extra_available_factories_for_food_reservation = (
        user.extra_available_factories_for_food_reservation.all()
    )

    if (
        role_name
        in ["super_admin", "holding_manager", "factory_manager", "department_manager"]
        or user.unlimit_reservation
        or user.guest_limit_reservation > 0
    ):
        can_reserve_guest = True

    if (
        role_name in ["holding_manager", "super_admin"]
        or extra_available_factories_for_food_reservation.exists()
    ):
        can_choose_factory = True

        target_factory_id = request.GET.get("target_factory_id") or request.POST.get(
            "target_factory_id"
        )

        if role_name == "super_admin":
            available_factories = Factory.objects.all()
        elif role_name == "holding_manager":
            available_factories = Factory.objects.filter(holding_id=holding_id).all()

        if is_committee:
            factory = Factory.objects.filter(id=factory_id).first().linked_factory
        else:
            factory = Factory.objects.filter(id=factory_id).first()

        if factory:
            available_factories = available_factories | Factory.objects.filter(
                pk=factory.pk
            )

        if extra_available_factories_for_food_reservation.exists():
            available_factories = (
                available_factories | extra_available_factories_for_food_reservation
            )

        available_factories = available_factories.distinct()

        if target_factory_id:
            try:
                selected_factory = Factory.objects.filter(id=target_factory_id).first()
                if selected_factory:
                    factory = selected_factory
                    request.session["food_target_factory_id"] = selected_factory.id
                else:
                    messages.error(request, "کارخانه انتخاب‌شده معتبر نیست.")
            except (ValueError, TypeError):
                messages.error(request, "شناسه کارخانه نامعتبر است.")
        elif request.session.get("food_target_factory_id") != None:
            # اگر هیچ target_factory_id نبود، از سشن قبلی استفاده کن
            session_factory_id = request.session.get("food_target_factory_id")
            if session_factory_id:
                selected_factory = available_factories.filter(
                    id=session_factory_id
                ).first()
                if selected_factory:
                    factory = selected_factory
        else:
            if role_name == "super_admin":
                factory = Factory.objects.first()
            elif role_name == "holding_manager":
                factory = Factory.objects.filter(holding_id=holding_id).first()
            else:
                factory = Factory.objects.filter(id=factory_id).first()

    else:
        if is_committee:
            factory = Factory.objects.filter(id=factory_id).first().linked_factory
        else:
            factory = Factory.objects.filter(id=factory_id).first()

    if not factory:
        messages.warning(
            request, "کارخانه شما مشخص نشده است. لطفا با بخش هوش مصنوعی تماس بگیرید."
        )
        return redirect("users:landing")

    close_food_res_time_H = (
        factory.close_food_res_time_H
        if (
            factory.close_food_res_time_H
            and factory.close_food_res_time_H >= 0
            and factory.close_food_res_time_H < 24
        )
        else default_close_food_res_time_H
    )
    close_food_res_time_M = (
        factory.close_food_res_time_M
        if (
            factory.close_food_res_time_M
            and factory.close_food_res_time_M >= 0
            and factory.close_food_res_time_M < 60
        )
        else default_close_food_res_time_M
    )

    days_until_saturday = today_jdate.weekday()
    base_week_start_jdate = today_jdate - timedelta(days=days_until_saturday)

    week_starts_jdate = [
        base_week_start_jdate + timedelta(days=7 * i) for i in range(weeks_count)
    ]
    full_start_date = week_starts_jdate[0].togregorian()
    full_end_date = (week_starts_jdate[-1] + timedelta(days=6)).togregorian()

    existing_reservations = (
        FoodReservation.objects.filter(
            employee=user,
            reservation_date__gte=full_start_date,
            reservation_date__lte=full_end_date,
            related_factory=factory,
            is_canceled=False,
            menu_item__food__is_management_food=True,
        )
        .select_related(
            "menu_item__food", "menu_item__weekly_menu__restaurant__department"
        )
        .order_by("reserved_at")
        .all()
    )

    def get_weekly_menus_for_week(week_start_date):
        latest_start_dates = (
            WeeklyMenu.objects.filter(
                restaurant__department__factory=factory,
                week_start_date__lte=week_start_date,
            )
            .values("restaurant")
            .annotate(latest_start_date=Max("week_start_date"))
        )

        if not latest_start_dates.exists():
            return WeeklyMenu.objects.none()

        q_objects = Q()
        for item in latest_start_dates:
            q_objects |= Q(
                restaurant_id=item["restaurant"],
                week_start_date=item["latest_start_date"],
            )

        return (
            WeeklyMenu.objects.filter(q_objects)
            .select_related("restaurant", "restaurant__department")
            .all()
        )

    weekly_data = []
    week_days = [code for code, name in PERSIAN_WEEK_DAYS]

    for week_index, week_start_jdate in enumerate(week_starts_jdate, start=1):
        week_start_date = week_start_jdate.togregorian()
        week_end_date = week_start_date + timedelta(days=6)

        weekly_menus = get_weekly_menus_for_week(week_start_date)

        if weekly_menus:
            all_menu_items = (
                MenuItem.objects.filter(
                    weekly_menu__in=weekly_menus,
                    food__is_management_food=True,
                )
                .select_related("food", "weekly_menu__restaurant")
                .all()
            )
        else:
            all_menu_items = MenuItem.objects.none()

        for i, day_code in enumerate(week_days):
            day_date_j = week_start_jdate + jdatetime.timedelta(days=i)
            day_date_g = week_start_date + timedelta(days=i)
            day_name = dict(PERSIAN_WEEK_DAYS)[day_code]

            menus = all_menu_items.filter(day_persian=day_code)

            is_reservation_possible = day_date_g >= today_gdate

            tehran_aware_datetime = timezone.localtime(timezone.now())
            is_reservation_time_passed = False
            if day_date_g == today_gdate:
                is_reservation_time_passed = tehran_aware_datetime.time() > time(
                    close_food_res_time_H, close_food_res_time_M
                )

            is_today_comment_time = not is_reservation_possible or (
                day_date_g == today_gdate
                and tehran_aware_datetime.time()
                > time(start_today_food_comment_time_H, start_today_food_comment_time_M)
            )

            available_menu_ids = list(menus.values_list("id", flat=True))

            day_reservations = existing_reservations.filter(reservation_date=day_date_g)

            user_food_ids = day_reservations.values_list("menu_item__id", flat=True)

            users_feedbacks = (
                FoodReservation.objects.filter(
                    menu_item__id__in=user_food_ids,
                    menu_item__food__is_management_food=True,
                )
                .exclude(Q(feedback__isnull=True) & Q(rating__isnull=True))
                .select_related("menu_item__food", "employee")
            )

            day_food_feedbacks = {}

            for item in users_feedbacks:
                food_id = item.menu_item.id
                user_can_comment = True if item.employee != user else False

                if food_id not in day_food_feedbacks:
                    day_food_feedbacks[food_id] = {"comments": [], "ratings": []}

                if item.feedback:
                    day_food_feedbacks[food_id]["comments"].append(
                        {
                            "text": item.feedback,
                            "rating": item.rating,
                            "user": item.employee.full_name,
                            "date": item.reserved_at,
                            "user_can_comment": user_can_comment,
                        }
                    )

                if item.rating:
                    day_food_feedbacks[food_id]["ratings"].append(item.rating)

            weekly_data.append(
                {
                    "week_index": week_index,
                    "week_start_date": week_start_date,
                    "week_end_date": week_end_date,
                    "day_name": day_name,
                    "jdate_str": day_date_j.strftime("%Y/%m/%d"),
                    "gdate_str": day_date_g.strftime("%Y-%m-%d"),
                    "menus": menus,
                    "is_reservation_possible": is_reservation_possible,
                    "is_reservation_time_passed": is_reservation_time_passed,
                    "available_menu_ids": available_menu_ids,
                    "average_ratings": 3.5,
                    "user_can_comment": True,
                    "day_reservations": day_reservations,
                    "day_food_feedbacks": day_food_feedbacks,
                    "reservation_time_limit": time(
                        close_food_res_time_H, close_food_res_time_M
                    ),
                    "is_today_comment_time": is_today_comment_time,
                }
            )

    if request.method == "POST" and "submit_reservations" in request.POST:

        post_token = request.POST.get("form_token")
        session_token = request.session.get("form_token")

        if not post_token or post_token != session_token:
            messages.error(request, "فرم معتبر نیست. لطفا مجددا تلاش کنید.")
            return redirect(request.path)

        # بعد از پردازش موفق، توکن جدید ایجاد کن
        request.session["form_token"] = get_random_string(32)

        is_reservation_time_passed = tehran_aware_datetime.time() > time(
            close_food_res_time_H, close_food_res_time_M
        )

        today = tehran_aware_datetime.date()

        parsed_reservations = []

        for key, value in request.POST.items():
            print("key : ", key, "value : ", value)
            if not key.startswith("reservations["):
                continue

            parts = key.split("][")

            date_str = parts[0].replace("reservations[", "")
            index = parts[1]
            field = parts[2].replace("]", "")

            if date_str not in [d["date"] for d in parsed_reservations]:
                pass  # handled below

            # یک دیکشنری پیدا کن (یا بساز)
            target_key = f"{date_str}-{index}"

            if target_key not in [r.get("key") for r in parsed_reservations]:
                parsed_reservations.append(
                    {
                        "key": target_key,
                        "date": date_str,
                        "food_choice": None,
                        "quantity": None,
                        "price_type": None,
                    }
                )

            # دیکشنری مربوطه را بگیر
            target = next(r for r in parsed_reservations if r["key"] == target_key)

            # حالا مقدار فیلد را ثبت کن
            if field == "food_choice":
                target["food_choice"] = int(value)
            elif field == "quantity":
                target["quantity"] = int(value)
            elif field == "price_type":
                target["price_type"] = value

        # حذف رکوردهای خالی یا food_choice=0
        parsed_reservations = [
            r
            for r in parsed_reservations
            if r["food_choice"] not in [None, 0] and r["quantity"] > 0
        ]

        if not is_reservation_time_passed:
            FoodReservation.objects.filter(
                employee=user,
                related_factory=factory,
                reservation_date__gte=today,
                menu_item__food__is_management_food=True,
            ).delete()
        else:
            FoodReservation.objects.filter(
                employee=user,
                related_factory=factory,
                reservation_date__gt=today,
                menu_item__food__is_management_food=True,
            ).delete()

        for item in parsed_reservations:

            date_g = datetime.strptime(item["date"], "%Y-%m-%d").date()

            menu_item = MenuItem.objects.filter(
                id=item["food_choice"],
                food__is_management_food=True,
            ).first()
            if not menu_item:
                continue

            # نوع قیمت → انتخاب فیلدها
            fq = ffree = fg = 0
            if item["price_type"] == "factory":
                fq = item["quantity"]
                fq = fq if (fq <= max_factory_quantity) else max_factory_quantity
                unit_price = menu_item.food.factory_price
            elif item["price_type"] == "free":
                ffree = item["quantity"]
                ffree = ffree if (ffree <= max_free_quantity) else max_free_quantity
                unit_price = menu_item.food.free_price
            elif item["price_type"] == "guest":
                if can_reserve_guest:
                    fg = item["quantity"]
                    fg = fg if (fg <= max_guest_quantity) else max_guest_quantity
                    print(f"done{fg}")
                else:
                    print("0")
                    fg = 0
                unit_price = menu_item.food.guest_price

            # -----------------------------------------
            # 1) چک کن آیا رکورد موجود هست؟
            # -----------------------------------------
            existing = FoodReservation.objects.filter(
                employee=request.user,
                reservation_date=date_g,
                menu_item=menu_item,
                related_factory=factory,
                is_canceled=False,
                menu_item__food__is_management_food=True,
            ).first()

            if existing:
                # -----------------------------------------
                # 2) اگر هست → فقط مقدارها رو اضافه کن
                # -----------------------------------------
                existing.factory_quantity += fq
                existing.free_quantity += ffree
                existing.guest_quantity += fg

                existing.factory_quantity = (
                    existing.factory_quantity
                    if (existing.factory_quantity <= max_factory_quantity)
                    else max_factory_quantity
                )
                existing.free_quantity = (
                    existing.free_quantity
                    if (existing.free_quantity <= max_free_quantity)
                    else max_free_quantity
                )
                existing.guest_quantity = (
                    existing.guest_quantity
                    if (existing.guest_quantity <= max_guest_quantity)
                    else max_guest_quantity
                )

                # قیمت‌ها یک بار برای همیشه ثابت می‌مونن
                existing.factory_price = menu_item.food.factory_price
                existing.free_price = menu_item.food.free_price
                existing.guest_price = menu_item.food.guest_price

                # total_price باید مجموع همه‌ی قیمت‌ها بشه
                existing.total_price = (
                    existing.factory_quantity * existing.factory_price
                    + existing.free_quantity * existing.free_price
                    + existing.guest_quantity * existing.guest_price
                )

                existing.save()
                continue

            # -----------------------------------------
            # 3) اگر نبود → رکورد جدید بساز
            # -----------------------------------------
            FoodReservation.objects.create(
                employee=request.user,
                menu_item=menu_item,
                reservation_date=date_g,
                related_factory=factory,
                factory_quantity=fq,
                free_quantity=ffree,
                guest_quantity=fg,
                factory_price=menu_item.food.factory_price,
                free_price=menu_item.food.free_price,
                guest_price=menu_item.food.guest_price,
                total_price=(unit_price * item["quantity"]),
            )
        messages.success(request, "رزروهای شما با موفقیت ثبت شدند.")
        return redirect(request.path)

    elif request.method == "POST" and "submit_comment" in request.POST:
        # print("comment")
        # print(request.POST)
        comment_text = request.POST.get("comment_text")
        rating = request.POST.get("rating")
        menu_item_id = request.POST.get("menu_item_id")
        comment_date = request.POST.get("comment_date")

        # print(comment_text)
        # print(rating)
        # print(menu_item_id)
        # print(comment_date)

        existing = FoodReservation.objects.filter(
            employee=request.user,
            reservation_date=comment_date,
            menu_item__id=menu_item_id,
            related_factory=factory,
            menu_item__food__is_management_food=True,
        ).first()

        # آپدیت نظر و امتیاز
        existing.feedback = comment_text
        existing.rating = rating

        existing.save(update_fields=["feedback", "rating"])

    context = {
        "weekly_data": weekly_data,
        "week_start_date": week_start_date,
        "max_factory_quantity": max_factory_quantity,
        "max_free_quantity": max_free_quantity,
        "max_guest_quantity": max_guest_quantity,
        "can_reserve_guest": can_reserve_guest,
        "user_factory_name": factory.name,
        "can_choose_factory": can_choose_factory,
        "available_factories": available_factories,
        "selected_factory_id": factory.id,
        "current_factory_id": factory.id,
        "today_gdate_str": tehran_aware_datetime.date(),
        "is_reservation_time_passed": is_reservation_time_passed,
        "form_token": form_token,
        "can_reserve_management_food": can_reserve_management_food,
    }

    # print(f"context : {context}")

    return render(request, "users/food_reservation.html", context)


def get_factory_ids(employee):

    # MARK: committee todo
    related_holdings = (
        Holding.objects.filter(
            # Q(manager=employee) |
            Q(managers=employee)
            # | Q(factories__manager=employee)
            | Q(factories__managers=employee)
            # | Q(factories__departments__manager=employee)
            | Q(factories__departments__managers=employee)
            | Q(
                factories__departments__manager_2=employee
            )  # 🌟 جدید: اضافه کردن manager_2 و manager_3 برای department
            | Q(factories__departments__manager_3=employee)
            # | Q(factories__departments__subdepartments__supervisor=employee)
            | Q(factories__departments__subdepartments__supervisors=employee)
            | Q(factories__departments__subdepartments__assigned_employees=employee)
        )
        .distinct()
        .order_by("name")
    )

    management_tree_1 = []
    factory_ids = []
    managing_holdings_ids = []
    is_holding_manager = False

    for holding in related_holdings:
        holding_dict = {
            "id": holding.id,
            "name": holding.name,
            "role": (
                "holding_manager"
                if holding.managers.filter(id=employee.id).exists()
                else None
            ),
            "factories": [],
        }

        if (
            is_holding_manager == False
            and holding.managers.filter(id=employee.id).exists()
        ):
            is_holding_manager = True

        if holding.managers.filter(id=employee.id).exists():
            managing_holdings_ids.append(holding.id)

        # کارخانه‌های مرتبط در این هلدینگ
        related_factories = (
            Factory.objects.filter(holding=holding)
            .filter(
                Q(managers=employee)
                # | Q(departments__manager=employee)
                | Q(departments__managers=employee)
                | Q(departments__manager_2=employee)
                | Q(departments__manager_3=employee)
                # | Q(departments__subdepartments__supervisor=employee)
                | Q(departments__subdepartments__supervisors=employee)
                | Q(departments__subdepartments__assigned_employees=employee)
            )
            .distinct()
            .order_by("name")
        )
        for factory in related_factories:
            factory_dict = {
                "id": factory.id,
                "name": factory.name,
                "role": (
                    "factory_manager"
                    if factory.managers.filter(id=employee.id).exists()
                    else None
                ),
            }
            factory_ids.append(factory.id)
            holding_dict["factories"].append(factory_dict)

        if holding_dict:
            management_tree_1.append(holding_dict)

    # MARK: committee todo end

    return factory_ids, management_tree_1, is_holding_manager, managing_holdings_ids


@login_required
def get_employee_reservation_info(request):

    today_gdate = date.today()
    today_jdate = jdatetime.date.today()
    user = request.user
    can_reserve_for_others = user.can_reserve_for_others
    can_reserve_for_which_day = user.can_reserve_for_which_day

    if can_reserve_for_which_day == 1:
        for_date = request.GET.get("for_date")
        if for_date:
            try:
                # جدا کردن سال، ماه، روز
                jy, jm, jd = map(int, for_date.split("/"))

                # تاریخ شمسی انتخاب‌شده
                selected_jdate = jdatetime.date(jy, jm, jd)

                # تاریخ میلادی معادل
                selected_gdate = selected_jdate.togregorian()

            except (ValueError, TypeError):
                # اگر فرمت اشتباه بود
                selected_jdate = None
                selected_gdate = None
        else:
            selected_jdate = None
            selected_gdate = None

        today_gdate = selected_gdate
        today_jdate = selected_jdate

    if request.method != "GET":
        return JsonResponse({"error": "Method not allowed"}, status=405)

    q = request.GET.get("q")  # national_id یا personnel_code یا id

    if not q:
        return JsonResponse({"error": "No query"}, status=400)

    try:
        employee = Employee.objects.filter(
            Q(national_id=q) | Q(personnel_code=q) | Q(id=q)
        ).first()

        if not employee:
            return JsonResponse({"found": False})

        # محاسبه مجوزها (کاملاً مشابه منطق ویو اصلی)
        can_guest = employee.unlimit_reservation  # or employee.role_name in [

        can_management = employee.can_reserve_management_food

        existing_reservations_qs = FoodReservation.objects.filter(
            employee=employee,
            reservation_date=today_gdate,  # تبدیل به میلادی
            is_canceled=False,
            reserved_by=request.user.id,
        ).select_related("menu_item__food", "menu_item__weekly_menu__restaurant")

        existing_reservations = [
            {
                "id": res.id,
                "menu_item": res.menu_item.id,
                "factory_quantity": res.factory_quantity,
                "free_quantity": res.free_quantity,
                "guest_quantity": res.guest_quantity,
            }
            for res in existing_reservations_qs
        ]

        total_factory_res = 0
        total_free_res = 0
        total_guest_res = 0

        all_existing_reservations_qs = FoodReservation.objects.filter(
            employee=employee,
            reservation_date=today_gdate,  # تبدیل به میلادی
            is_canceled=False,
        ).select_related("menu_item__food", "menu_item__weekly_menu__restaurant")

        for res in all_existing_reservations_qs:
            total_factory_res = total_factory_res + int(res.factory_quantity)
            total_free_res = total_free_res + int(res.free_quantity)
            total_guest_res = total_guest_res + int(res.guest_quantity)

        factory_ids, management_tree_1, is_holding_manager, managing_holdings_ids = (
            get_factory_ids(employee)
        )

        print(f"factory_ids : {factory_ids}")

        # گرفتن شناسه‌های کارخانه‌های اضافی از فیلد ManyToMany کاربر
        extra_ids = list(
            employee.extra_available_factories_for_food_reservation.values_list(
                "id", flat=True
            )
        )

        # اضافه کردن به لیست اصلی
        factory_ids.extend(extra_ids)

        # حذف شناسه‌های تکراری (در صورت نیاز) با حفظ ترتیب
        factory_ids = list(dict.fromkeys(factory_ids))

        # print(f"factory_ids after adding extra: {factory_ids}")

        if employee.is_staff:
            factories = Factory.objects.all()
        elif is_holding_manager:
            factories = Factory.objects.filter(
                Q(holding_id__in=managing_holdings_ids) | Q(id__in=factory_ids)
            ).all()
        else:
            factories = Factory.objects.filter(id__in=factory_ids)

        available_menus = []
        available_factories = []
        # menu_list = []

        for factory in factories:

            menu_list = []

            can_reserve_management_food = employee.can_reserve_management_food

            days_until_saturday = today_jdate.weekday()

            week_start_jdate = today_jdate - timedelta(days=days_until_saturday)

            week_start_date = (
                week_start_jdate.togregorian()
            )  # تاریخ میلادی برای جستجوی WeeklyMenu

            latest_start_dates = (
                WeeklyMenu.objects.filter(
                    restaurant__department__factory=factory,
                    week_start_date__lte=week_start_date,
                )
                .values("restaurant")
                .annotate(latest_start_date=Max("week_start_date"))
            )

            # 2. ساخت Q object برای فچ کردن منوهای دقیق (Greatest-N-per-Group)
            q_objects = Q()
            if latest_start_dates.exists():
                for item in latest_start_dates:
                    # ترکیب شناسه رستوران و آخرین تاریخ شروع آن
                    q_objects |= Q(
                        restaurant_id=item["restaurant"],
                        week_start_date=item["latest_start_date"],
                    )

                # فچ کردن منوهای هفتگی که شرایط Q object را دارند
                weekly_menus = (
                    WeeklyMenu.objects.filter(q_objects)
                    .select_related("restaurant", "restaurant__department")
                    .all()
                )
            else:
                weekly_menus = WeeklyMenu.objects.none()

            if weekly_menus:
                if not can_reserve_management_food:

                    all_menu_items = (
                        MenuItem.objects.filter(
                            weekly_menu__in=weekly_menus, food__is_management_food=False
                        )
                        .select_related("food", "weekly_menu__restaurant")
                        .all()
                    )

                else:
                    all_menu_items = (
                        MenuItem.objects.filter(weekly_menu__in=weekly_menus)
                        .select_related("food", "weekly_menu__restaurant")
                        .all()
                    )

            else:
                all_menu_items = MenuItem.objects.none()

            week_days = [code for code, name in PERSIAN_WEEK_DAYS]

            for i, day_code in enumerate(week_days):
                day_date_j = week_start_jdate + jdatetime.timedelta(days=i)
                day_date_g = week_start_date + timedelta(days=i)
                day_name = dict(PERSIAN_WEEK_DAYS)[day_code]

                # لیست منوها برای این روز (هر ترکیب غذا + رستوران جداگانه)
                menus = all_menu_items.filter(day_persian=day_code)

                is_today = day_date_g == today_gdate

                if is_today and menus:

                    menu_list.extend(
                        {
                            "menu_item": menu.id,
                            "menu_item__food__name": menu.food.name,
                            "restaurant_name": menu.weekly_menu.restaurant.name,
                            "factory_price": menu.food.factory_price,
                            "free_price": menu.food.free_price,
                            "guest_price": menu.food.guest_price,
                        }
                        for menu in menus
                    )

                    # menu_qs = menus

                    available_menus.append(
                        {
                            "factory_name": factory.name,
                            "factory_id": factory.id,
                            "menu": menu_list,
                        }
                    )

        if user.can_reserve_for_others == 2:
            # بدون محدودیت مقصد
            max_factory = user.factory_limit_reservation_for_others
            max_free = user.free_limit_reservation_for_others
            max_guest = user.guest_limit_reservation_for_others
            can_reserve_guest = user.guest_limit_reservation_for_others > 0
        elif user.can_reserve_for_others == 1:
            # با محدودیت مقصد
            emp_factory_limit = (
                employee.factory_limit_reservation
                if not employee.unlimit_reservation
                else 999999
            )
            emp_free_limit = (
                employee.free_limit_reservation
                if not employee.unlimit_reservation
                else 999999
            )
            emp_guest_limit = (
                employee.guest_limit_reservation
                if not employee.unlimit_reservation
                else 999999
            )

            max_factory = min(
                user.factory_limit_reservation_for_others, emp_factory_limit
            )
            max_free = min(user.free_limit_reservation_for_others, emp_free_limit)
            max_guest = min(user.guest_limit_reservation_for_others, emp_guest_limit)
            can_reserve_guest = user.guest_limit_reservation_for_others > 0 and (
                employee.unlimit_reservation or employee.guest_limit_reservation > 0
            )
        else:
            # مجاز نیست (اما نباید به اینجا برسد)
            max_factory = max_free = max_guest = 0
            can_reserve_guest = False

        # max_factory_quantity = request.user.factory_limit_reservation_for_others
        # max_free_quantity = request.user.free_limit_reservation_for_others
        # max_guest_quantity = request.user.guest_limit_reservation_for_others

        context = {
            "found": True,
            "id": employee.id,
            "full_name": employee.full_name,
            "national_id": employee.national_id,
            "personnel_code": employee.personnel_code,
            # "can_reserve_guest": can_guest,
            "can_reserve_management_food": can_management,
            "existing_reservations": existing_reservations,
            # "max_factory_quantity": max_factory_quantity,
            # "max_free_quantity": max_free_quantity,
            # "max_guest_quantity": max_guest_quantity,
            "max_factory_quantity": max_factory,
            "max_free_quantity": max_free,
            "max_guest_quantity": max_guest,
            "can_reserve_guest": can_reserve_guest,
            "total_factory_res": total_factory_res,
            "total_free_res": total_free_res,
            "total_guest_res": total_guest_res,
            # "factory": factory,
            "available_menus": available_menus,
        }

        return JsonResponse(context)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)


@transaction.atomic
@login_required
def food_reservation_for_others(request):

    user = request.user
    can_reserve_for_others = user.can_reserve_for_others
    can_reserve_for_which_day = user.can_reserve_for_which_day

    today_gdate = date.today()
    today_jdate = jdatetime.date.today()
    # print(today_jdate.strftime("%Y/%m/%d"))

    if can_reserve_for_which_day == 1:
        for_date = request.POST.get("for_date")
        if for_date:
            try:
                # جدا کردن سال، ماه، روز
                jy, jm, jd = map(int, for_date.split("/"))

                # تاریخ شمسی انتخاب‌شده
                selected_jdate = jdatetime.date(jy, jm, jd)

                # تاریخ میلادی معادل
                selected_gdate = selected_jdate.togregorian()

            except (ValueError, TypeError):
                # اگر فرمت اشتباه بود
                selected_jdate = None
                selected_gdate = None
        else:
            selected_jdate = None
            selected_gdate = None

        today_gdate = selected_gdate
        today_jdate = selected_jdate

    max_factory_quantity_for_others = request.user.factory_limit_reservation_for_others
    max_free_quantity_for_others = request.user.free_limit_reservation_for_others
    max_guest_quantity_for_others = request.user.guest_limit_reservation_for_others

    # number_of_factory_quantity_reserved_for_others = 0
    # number_of_free_quantity_reserved_for_others = 0
    # number_of_guest_quantity_reserved_for_others = 0

    # total_reservations_for_others = FoodReservation.objects.filter(
    #     reserved_by=user.id, reservation_date=today_gdate
    # )
    # for res in total_reservations_for_others:
    #     number_of_factory_quantity_reserved_for_others = (
    #         number_of_factory_quantity_reserved_for_others + res.factory_quantity
    #     )
    #     number_of_free_quantity_reserved_for_others = (
    #         number_of_free_quantity_reserved_for_others + res.free_quantity
    #     )
    #     number_of_guest_quantity_reserved_for_others = (
    #         number_of_guest_quantity_reserved_for_others + res.guest_quantity
    #     )

    if request.method == "POST":
        action = request.POST.get("action")

        if action == "save_group":

            # مرحله ۱: parse خام به شکل employee → لیست سفارش‌ها
            raw_orders = defaultdict(list)

            for key, value_list in request.POST.lists():
                if not key.startswith("full_reservations["):
                    continue

                match = re.match(r"full_reservations\[(\d+)\]\[(\d+)\]\[(\w+)\]", key)
                if not match:
                    continue

                employee_id, slot_index, field = match.groups()
                value = value_list[0] if value_list else ""

                orders = raw_orders[employee_id]
                target_index = int(slot_index)

                while len(orders) <= target_index:
                    orders.append({})

                orders[target_index][field] = value

            # مرحله ۲: merge سفارش‌ها برای هر کارمند (غذای یکسان → جمع مقادیر)
            merged_reservations = defaultdict(list)

            # print(f"ordersssssssssssssss{orders}")

            try:

                for employee_id, orders in raw_orders.items():
                    food_map = defaultdict(
                        lambda: {
                            "factory_quantity": 0,
                            "free_quantity": 0,
                            "guest_quantity": 0,
                        }
                    )

                    for order in orders:
                        food_id = order.get("menu_item")
                        if not food_id or food_id == "0":
                            continue  # بدون غذا → رد

                        ptype = order.get("price_type")

                        food_map[food_id]["factory_quantity"] = int(
                            order.get("factory_quantity", 0)
                        )

                        food_map[food_id]["free_quantity"] = int(
                            order.get("free_quantity", 0)
                        )

                        food_map[food_id]["guest_quantity"] = int(
                            order.get("guest_quantity", 0)
                        )

                    # print(f"food mapppppppppppppp{food_map}")
                    # تبدیل به لیست نهایی (فقط مواردی که حداقل یک مقدار > 0 دارند)

                    for food_id, qtys in food_map.items():
                        total_qty = sum(qtys.values())
                        if total_qty >= 0:
                            merged_reservations[employee_id].append(
                                {
                                    "food_choice": food_id,
                                    "factory_quantity": str(qtys["factory_quantity"]),
                                    "free_quantity": str(qtys["free_quantity"]),
                                    "guest_quantity": str(qtys["guest_quantity"]),
                                }
                            )

                # حالا merged_reservations دقیقاً همان ساختار دلخواه شماست
                # مثال خروجی برای داده POST شما:
                # {
                #     '26': [
                #         {'food_choice': '460', 'factory_quantity': '1', 'free_quantity': '0', 'guest_quantity': '1'},
                #         {'food_choice': '458', 'factory_quantity': '0', 'free_quantity': '3', 'guest_quantity': '0'},
                #         {'food_choice': '474', 'factory_quantity': '0', 'free_quantity': '1', 'guest_quantity': '0'},
                #     ],
                #     '27': [
                #         {'food_choice': '460', 'factory_quantity': '0', 'free_quantity': '1', 'guest_quantity': '0'},
                #     ]
                # }

                # مرحله ۳: ذخیره‌سازی در دیتابیس
                # today = date.today()
                today = today_gdate

                for employee_id, items in merged_reservations.items():
                    try:
                        employee = Employee.objects.get(id=employee_id)
                    except Employee.DoesNotExist:
                        messages.error(
                            request, f"کارمند با شناسه {employee_id} یافت نشد."
                        )
                        continue

                    can_guest = employee.unlimit_reservation
                    can_management = employee.can_reserve_management_food

                    total_factory_res = 0
                    total_free_res = 0
                    total_guest_res = 0

                    all_existing_reservations_qs = (
                        FoodReservation.objects.filter(
                            employee=employee,
                            reservation_date=today_gdate,  # تبدیل به میلادی
                            is_canceled=False,
                        )
                        .select_related(
                            "menu_item__food", "menu_item__weekly_menu__restaurant"
                        )
                        .exclude(reserved_by=user.id)
                    )

                    for res in all_existing_reservations_qs:
                        total_factory_res = total_factory_res + int(
                            res.factory_quantity
                        )
                        total_free_res = total_free_res + int(res.free_quantity)
                        total_guest_res = total_guest_res + int(res.guest_quantity)

                    rest_of_factory = (
                        max_factory_quantity_for_others - total_factory_res
                    )
                    rest_of_free = max_free_quantity_for_others - total_free_res
                    rest_of_guest = max_guest_quantity_for_others - total_guest_res

                    for item in items:
                        food_id = item["food_choice"]
                        try:
                            menu_item = MenuItem.objects.get(id=food_id)
                        except MenuItem.DoesNotExist:
                            messages.warning(
                                request,
                                f"غذا با شناسه {food_id} یافت نشد (کارمند {employee_id}).",
                            )
                            continue

                        factory = (
                            MenuItem.objects.filter(id=food_id)
                            .select_related(
                                "weekly_menu__restaurant__department__factory"
                            )
                            .values_list(
                                "weekly_menu__restaurant__department__factory__id",
                                "weekly_menu__restaurant__department__factory__name",
                                flat=False,
                            )
                            .first()
                        )
                        if factory:
                            factory_id, factory_name = factory
                            # print(f"کارخانه: {factory_name} (ID: {factory_id})")
                        else:
                            # print("منو آیتم پیدا نشد")
                            continue

                        # چک وجود رزرو قبلی برای همین غذا + تاریخ + کارمند
                        existing = FoodReservation.objects.filter(
                            employee=employee,
                            menu_item=menu_item,
                            reservation_date=today,
                            is_canceled=False,
                            reserved_by=request.user.id,
                            related_factory_id=factory_id,
                        ).first()

                        factory_quantity = 0
                        free_quantity = 0
                        guest_quantity = 0

                        # آپدیت (جمع با مقادیر قبلی - اگر لازم است)
                        if int(item["factory_quantity"]) < rest_of_factory:
                            factory_quantity = int(item["factory_quantity"])
                            rest_of_factory = (
                                (rest_of_factory - int(item["factory_quantity"]))
                                if (rest_of_factory - int(item["factory_quantity"]))
                                >= 0
                                else 0
                            )
                        else:
                            factory_quantity = rest_of_factory
                            rest_of_factory = 0

                        if int(item["free_quantity"]) < rest_of_free:
                            free_quantity = int(item["free_quantity"])
                            rest_of_free = (
                                (rest_of_free - int(item["free_quantity"]))
                                if (rest_of_free - int(item["free_quantity"])) >= 0
                                else 0
                            )
                        else:
                            free_quantity = rest_of_free
                            rest_of_free = 0

                        if int(item["guest_quantity"]) < rest_of_guest:
                            guest_quantity = int(item["guest_quantity"])
                            rest_of_guest = (
                                (rest_of_guest - int(item["guest_quantity"]))
                                if (rest_of_guest - int(item["guest_quantity"])) >= 0
                                else 0
                            )
                        else:
                            guest_quantity = rest_of_guest
                            rest_of_guest = 0

                        total_price = (
                            (menu_item.food.factory_price * factory_quantity)
                            + (menu_item.food.free_price * free_quantity)
                            + (menu_item.food.guest_price * guest_quantity)
                        )

                        reservation_is_canceled = 0

                        if (
                            (factory_quantity == 0)
                            and (free_quantity == 0)
                            and (guest_quantity == 0)
                        ):
                            reservation_is_canceled = 1

                        if existing:

                            if reservation_is_canceled:
                                existing.is_canceled = reservation_is_canceled

                            else:
                                existing.factory_quantity = factory_quantity
                                existing.free_quantity = free_quantity
                                existing.guest_quantity = guest_quantity
                                existing.factory_price = menu_item.food.factory_price
                                existing.free_price = menu_item.food.free_price
                                existing.guest_price = menu_item.food.guest_price
                                existing.total_price = total_price

                            existing.save()
                        else:
                            # ایجاد جدید
                            reservation = FoodReservation(
                                employee=employee,
                                menu_item=menu_item,
                                reservation_date=today,
                                factory_quantity=factory_quantity,
                                free_quantity=free_quantity,
                                guest_quantity=guest_quantity,
                                factory_price=menu_item.food.factory_price,
                                free_price=menu_item.food.free_price,
                                guest_price=menu_item.food.guest_price,
                                total_price=total_price,
                                reserved_by=request.user.id,
                                related_factory_id=factory_id,
                                is_canceled=reservation_is_canceled,
                            )
                            reservation.save()

                return JsonResponse(
                    {
                        "status": "success",
                        "message": f"رزروها با موفقیت ثبت شد.",
                        "saved_count": len(raw_orders),
                    }
                )

            except ValidationError as e:
                # دریافت لیست واقعی پیام‌ها
                if hasattr(e, "messages"):
                    error_messages = e.messages
                elif hasattr(e, "message_dict"):
                    error_messages = []
                    for field, msgs in e.message_dict.items():
                        error_messages.extend(msgs)
                else:
                    error_messages = [str(e)]

                # تبدیل newline به <br> در هر پیام و سپس اتصال با <br>
                clean_error = "<br>".join(
                    msg.replace("\n", "<br>") for msg in error_messages
                )

                return JsonResponse(
                    {"status": "error", "message": clean_error}, status=400
                )

        elif action == "delete_reservation":
            employee_id = request.POST.get("employee_id")
            menu_item_id = request.POST.get("menu_item")
            price_type = request.POST.get("price_type")
            quantity = int(request.POST.get("quantity", 0))

            # اینجا منطق حذف یا کاهش مقدار رو بنویس (مثال ساده):
            try:
                reservation = FoodReservation.objects.filter(
                    employee_id=employee_id,
                    menu_item_id=menu_item_id,
                    # reservation_date=date.today(),
                    reserved_by=user.id,
                    is_canceled=False,
                ).first()

                # print(f"*************************{reservation}")
                # if price_type == 'factory':
                #     reservation.factory_quantity = max(0, reservation.factory_quantity - quantity)
                # elif price_type == 'free':
                #     reservation.free_quantity = max(0, reservation.free_quantity - quantity)
                # elif price_type == 'guest':
                #     reservation.guest_quantity = max(0, reservation.guest_quantity - quantity)

                # if reservation.factory_quantity == 0 and reservation.free_quantity == 0 and reservation.guest_quantity == 0:
                reservation.is_canceled = True
                reservation.save()

                return JsonResponse({"status": "success", "message": "رزرو حذف شد."})

            except FoodReservation.DoesNotExist:
                return JsonResponse(
                    {"status": "error", "message": "رزرو یافت نشد."}, status=404
                )

    else:
        # print(f"AAAAAA{request}")  # برای GET (رفرش صفحه)

        if can_reserve_for_others:

            today_jdate = jdatetime.date.today()
            context = {
                "can_reserve_for_which_day": can_reserve_for_which_day,
                "today_jdate": today_jdate.strftime("%Y/%m/%d"),
            }

            return render(request, "users/food_reservation_for_others.html", context)

        else:
            messages.error(request, "مجاز به دسترسی به این سرویس نیستید")
            # return redirect("users:dashboard")
            return redirect("users:landing")


@login_required
def load_more_participations(request):
    # تنظیم تعداد مشارکت‌ها در هر بار
    # PARTICIPATIONS_PER_LOAD = 20

    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    user = request.user
    management_tree = request.session.get("management_tree", [])

    # دریافت پارامتر offset از درخواست AJAX
    offset = int(request.GET.get("offset", 0))
    is_management = request.GET.get("management", "false") == "true"

    if is_management:
        if role_name == "super_admin":
            all_participations = Participation.objects.filter(
                status="approved"
            ).order_by("-created_at")
            all_employees = Employee.objects.all()
        elif role_name == "holding_manager":
            all_participations = Participation.objects.filter(
                holding_id=holding_id, status="approved"
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__department__factory__holding_id=holding_id
            ).distinct()
        elif role_name == "factory_manager":
            all_participations = Participation.objects.filter(
                factory_id=factory_id, status="approved"
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__department__factory_id=factory_id
            ).distinct()
        elif role_name == "department_manager":
            all_participations = Participation.objects.filter(
                department_id=department_id, status="manager_review"
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__department_id=department_id
            ).distinct()
        elif role_name == "supervisor":
            all_participations = Participation.objects.filter(
                subdepartment_id=subdepartment_id, status="supervisor_review"
            ).order_by("-created_at")
            all_employees = Employee.objects.filter(
                assigned_subdepartments__id=subdepartment_id
            ).distinct()

        # اعمال فیلترهای فرم (اگر در request.GET وجود داشته باشند)
        form = ManagementFilterForm(request.GET or None)
        if form.is_valid():
            factory = form.cleaned_data.get("factory")
            department = form.cleaned_data.get("department")
            role = form.cleaned_data.get("role")
            search_name = form.cleaned_data.get("search_name")
            if factory:
                all_participations = all_participations.filter(user__factory=factory)
            if department:
                all_participations = all_participations.filter(
                    user__department=department
                )
            if role:
                all_participations = all_participations.filter(user__role=role)
            if search_name:
                q_filter = (
                    Q(user__first_name__icontains=search_name)
                    | Q(user__last_name__icontains=search_name)
                    | Q(user__national_id__icontains=search_name)
                )
                all_participations = all_participations.filter(q_filter)

    else:
        # منطق فیلتر dashboard
        role_name = request.session.get("current_role")
        holding_id = request.session.get("current_holding_id")
        factory_id = request.session.get("current_factory_id")
        department_id = request.session.get("current_department_id")
        subdepartment_id = request.session.get("current_subdepartment_id")

        # اعمال فیلترهای نقش و مکان ذخیره شده در مدل Participation
        all_participations = Participation.objects.filter(
            user=request.user,
            role_name=role_name,
            holding_id=holding_id,
            factory_id=factory_id,
            department_id=department_id,
            subdepartment_id=subdepartment_id,
        ).order_by("-created_at")

    # اعمال بارگذاری تنبل
    participations = all_participations[offset : offset + PARTICIPATIONS_PER_LOAD]

    # تعیین اینکه آیا مشارکت‌های بیشتری برای بارگذاری وجود دارد
    has_more = all_participations.count() > (offset + len(participations))

    reviewers = ["super_admin", "holding_manager", "factory_manager"]

    # رندر کردن قطعه HTML جدول
    # از یک فایل تمپلیت مجزا برای سطرها استفاده کنید: 'users/participation_rows.html'
    context = {
        "participations": participations,
        "user": request.user,
        "is_management_view": is_management,
        "reviewers": reviewers,
    }
    html_content = render(
        request, "users/participation_rows.html", context
    ).content.decode("utf-8")

    return JsonResponse(
        {
            "html": html_content,
            "has_more": has_more,
            "new_offset": offset + len(participations),
        }
    )


def convert_value(key, value, ftype):
    """مقدار خام را به فرم مناسب مدل تبدیل می‌کند"""
    if ftype == "str":
        return value.strip() if value else ""
    elif ftype == "int":
        try:
            return int(value) if value not in [None, ""] else 0
        except (ValueError, TypeError):
            return 0
    elif ftype == "int_null":
        if value in [None, ""]:
            return None
        try:
            return int(value)
        except (ValueError, TypeError):
            return None
    elif ftype == "bool":
        return value == "True"
    elif ftype == "date":
        if value:
            try:
                return datetime.strptime(value, "%Y-%m-%d").date()
            except (ValueError, TypeError):
                return None
        return None
    else:
        return value


@login_required
def user_management(request):
    try:
        role_name = request.session["current_role"]
        holding_id = request.session["current_holding_id"]
        factory_id = request.session["current_factory_id"]
        department_id = request.session["current_department_id"]
        subdepartment_id = request.session["current_subdepartment_id"]
        user = request.user
        management_tree = request.session.get("management_tree", [])
        is_committee = request.session["current_is_committee"]
        real_role_name = request.GET.get("current_real_role")
    except Exception as e:
        messages.error(
            request,
            "متاسفانه در سامانه برای شما نقش و قسمت تعریف نشده است ، لطفا با واحد هوش مصنوعی تماس حاصل بفرمایید. 09136304789",
        )
        return logout_view(request)

    INITIAL_LOAD_COUNT = settings.USER_MANAGEMENT_INITIAL_LOAD_COUNT
    LOAD_MORE_COUNT = settings.USER_MANAGEMENT_LOAD_MORE_COUNT

    employee_fields = [f.name for f in Employee._meta.get_fields()]

    management_access = role_name in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]

    if not management_access:
        raise PermissionDenied("شما مجاز به دسترسی به این بخش نیستید.")

    """مدیریت کاربران - فقط برای super_admin, holding_manager, factory_manager, department_manager, supervisor"""
    # چک دسترسی
    user_role = request.user.roles.values_list("name", flat=True)
    user_role = role_name

    # print(user_role)

    form = ManagementFilterForm(request.GET or None)

    employees = (
        Employee.objects.filter(
            # Q(id__in=user.hr_accessible_employees.values_list("id", flat=True)) |
            Q(assigned_subdepartments__in=user.hr_accessible_subdepartments.all())
            | Q(
                assigned_subdepartments__department__in=user.hr_accessible_departments.all()
            )
            | Q(
                assigned_subdepartments__department__factory__in=user.hr_accessible_factories.all()
            )
            | Q(
                assigned_subdepartments__department__factory__holding__in=user.hr_accessible_holdings.all()
            )
            | Q(managed_holdings_m2m__in=user.hr_accessible_holdings.all())
            | Q(managed_factories_m2m__in=user.hr_accessible_factories.all())
            | Q(managed_departments_m2m__in=user.hr_accessible_departments.all())
            | Q(
                supervised_subdepartments_m2m__in=user.hr_accessible_subdepartments.all()
            )
        )
        .exclude(id=user.id)  # اگر نمی‌خوای خود مدیر داخل لیست باشه
        .distinct()
        .order_by("id")
    )

    holdings = user.hr_accessible_holdings.all()
    factories = (
        user.hr_accessible_factories.all()
        | Factory.objects.filter(holding__in=holdings)
    ).distinct()
    departments = (
        user.hr_accessible_departments.all()
        | Department.objects.filter(factory__in=factories)
    ).distinct()
    subdepartments = (
        user.hr_accessible_subdepartments.all()
        | Subdepartment.objects.filter(department__in=departments)
    ).distinct()

    # اضافه کردن فیلتر holding فقط برای super_admin
    if "super_admin" in user_role:
        if not hasattr(form.fields, "holding"):
            form.fields["holding"] = forms.ModelChoiceField(
                queryset=Holding.objects.all(), required=False, label="هلدینگ"
            )

    # اگر فرم معتبر است، فیلترها را اعمال کنید
    if form.is_valid():
        factory = form.cleaned_data.get("factory")
        department = form.cleaned_data.get("department")
        # تغییر role به roles_filter (چون role فیلد ManyToMany است)
        roles_filter = form.cleaned_data.get("roles_filter")  # باید در فرم آپدیت شود
        search_name = form.cleaned_data.get("search_name")
        holding = form.cleaned_data.get("holding")  # جدید

        if holding:
            employees = employees.filter(holding=holding)
        if factory:
            employees = employees.filter(factory=factory)
        if department:
            employees = employees.filter(department=department)
        if roles_filter:
            # فیلتر بر اساس roles (ManyToMany)
            employees = employees.filter(roles=roles_filter)
        if search_name:
            employees = employees.filter(
                Q(first_name__icontains=search_name)
                | Q(last_name__icontains=search_name)
                | Q(national_id__icontains=search_name)
            )

    if request.method == "POST":
        if request.POST.get("create_user") == "create":

            FIELD_DEFINITIONS = {
                # فیلدهای ساده (string)
                "national_id": "str",
                "personnel_code": "str",
                "first_name": "str",
                "last_name": "str",
                "phone_number": "str",
                "email": "str",
                "address": "str",
                "center_of_charge": "str",
                "birth_certificate_number": "str",
                "father_name": "str",
                "password": "str",
                "confirm_password": "str",
                # bool fields
                "unlimit_reservation": "bool",
                "is_contractor": "bool",
                # "can_serve_foods": "bool",
                # "can_access_dashboard": "bool",
                # "can_access_all_departments": "bool",
                # "factory_bimeh": "bool",
                # "holding_bimeh": "bool",
                # "can_reserve_management_food": "bool",
                # "manage_sub_employees": "bool",
                # "is_first_login": "bool",
                # "is_active": "bool",
                # # فیلدهای عددی (int)
                # "guest_limit_reservation": "int",
                # "free_limit_reservation": "int",
                # "factory_limit_reservation": "int",
                # "guest_limit_reservation_for_others": "int",
                # "free_limit_reservation_for_others": "int",
                # "factory_limit_reservation_for_others": "int",
                # "food_receiver_role": "int",
                # "can_reserve_for_others": "int",
                # "can_reserve_for_which_day": "int",
                # "reporting_permision": "int",
                # # فیلدهای خارجی (ForeignKey) - به صورت int ولی می‌تواند None باشد
                # "food_receiver_factory": "int_null",
                # "food_receiver_holding": "int_null",
                # "hr_granting_role_limit": "int_null",
                # "gender": "int_null",
                # "dependency_status": "int_null",
                # "marital_status": "int_null",
                # "birth_date": "date",
                # فیلدهای ManyToMany - به صورت list (از request.POST.getlist)
                "managing_holdings": "list",
                "managing_factories": "list",
                "managing_departments": "list",
                "supervising_subdepartments": "list",
                "assigned_subdepartments": "list",
                # "roles": "list",
                # "hr_accessible_holdings": "list",
                # "hr_accessible_factories": "list",
                # "hr_accessible_departments": "list",
                # "hr_accessible_subdepartments": "list",
                # "hr_accessible_employees": "list",
            }

            fields = [
                "password",
                "confirm_password",
                # هر فیلد تکی دیگر
            ]

            simple_fields = [f for f, t in FIELD_DEFINITIONS.items() if t != "list"]
            list_fields = [f for f, t in FIELD_DEFINITIONS.items() if t == "list"]

            data = {}
            for field in simple_fields:
                data[field] = request.POST.get(field)
            for field in list_fields:
                data[field] = request.POST.getlist(field)

            if data["national_id"] in [None, ""]:
                return JsonResponse(
                    {
                        "status": "message",
                        "title": "خطا",
                        "message": "لطفا کد ملی را به طور صحیح وارد کنید",
                        "icon": "error",
                        "timer": 2500,
                        "showConfirmButton": True,
                    }
                )
            try:
                existing_emp = Employee.objects.get(national_id=data["national_id"])
                is_exist = True
            except Employee.DoesNotExist:
                existing_emp = None
                is_exist = False

            if not is_exist:
                if not data.get("password") or data["password"] != data.get(
                    "confirm_password"
                ):
                    return JsonResponse(
                        {
                            "status": "message",
                            "title": "خطا",
                            "message": "رمز عبور و تکرار آن را صحیح وارد کنید",
                            "icon": "error",
                            "timer": 2500,
                            "showConfirmButton": True,
                        }
                    )
                hashed_password = make_password(data["password"])
            else:
                # در حالت ویرایش: اگر رمز جدید وارد شده باشد همان را هش کن، در غیر این صورت رمز قبلی حفظ شود
                if data.get("password") and data["password"] == data.get(
                    "confirm_password"
                ):
                    hashed_password = make_password(data["password"])
                else:
                    hashed_password = existing_emp.password

            REQUIRED_FIELDS = ["national_id", "first_name", "last_name", "phone_number"]

            if any(
                data.get(f) in [None, ""]
                for f in REQUIRED_FIELDS
                if not (is_exist and f == "national_id")
            ):
                return JsonResponse(
                    {
                        "status": "message",
                        "title": "خطا",
                        "message": "لطفا فیلدهای اجباری را پر کنید",
                        "icon": "error",
                        "timer": 2500,
                        "showConfirmButton": True,
                    }
                )

            # # تبدیل به لیست اعداد صحیح (مقادیر خالی حذف شوند)
            # new_holdings = [int(id) for id in data["managing_holdings"] if id]
            # new_factories = [int(id) for id in data["managing_factories"] if id]
            # new_departments = [int(id) for id in data["managing_departments"] if id]
            # new_supervising = [int(id) for id in data["supervising_subdepartments"] if id]
            # new_assigned = [int(id) for id in data["assigned_subdepartments"] if id]

            # # اگر کاربر از قبل وجود دارد، ترکیب رول‌ها را انجام بده
            # if is_exist:
            #     # دریافت رول‌های فعلی کاربر
            #     current_holdings = list(
            #         existing_emp.managed_holdings_m2m.all().values_list("id", flat=True)
            #     )
            #     current_factories = list(
            #         existing_emp.managed_factories_m2m.all().values_list(
            #             "id", flat=True
            #         )
            #     )
            #     current_departments = list(
            #         existing_emp.managed_departments_m2m.all().values_list(
            #             "id", flat=True
            #         )
            #     )
            #     current_supervising = list(
            #         existing_emp.supervised_subdepartments_m2m.all().values_list(
            #             "id", flat=True
            #         )
            #     )
            #     current_assigned = list(
            #         existing_emp.assigned_subdepartments.all().values_list(
            #             "id", flat=True
            #         )
            #     )

            #     # مجموعه دسترسی‌های HR
            #     accessible_holdings = set(
            #         user.hr_accessible_holdings.all().values_list("id", flat=True)
            #     )
            #     accessible_factories = set(
            #         user.hr_accessible_factories.all().values_list("id", flat=True)
            #     )
            #     accessible_departments = set(
            #         user.hr_accessible_departments.all().values_list("id", flat=True)
            #     )
            #     accessible_subdepartments = set(
            #         user.hr_accessible_subdepartments.all().values_list("id", flat=True)
            #     )

            #     # ترکیب رول‌ها:
            #     # رول‌هایی که HR دسترسی دارد -> جایگزین با مقادیر جدید
            #     # رول‌هایی که HR دسترسی ندارد -> همان مقادیر قبلی حفظ شوند
            #     final_holdings = [
            #         h for h in new_holdings if h in accessible_holdings
            #     ] + [h for h in current_holdings if h not in accessible_holdings]

            #     final_factories = [
            #         f for f in new_factories if f in accessible_factories
            #     ] + [f for f in current_factories if f not in accessible_factories]

            #     final_departments = [
            #         d for d in new_departments if d in accessible_departments
            #     ] + [d for d in current_departments if d not in accessible_departments]

            #     final_supervising = [
            #         s for s in new_supervising if s in accessible_subdepartments
            #     ] + [
            #         s for s in current_supervising if s not in accessible_subdepartments
            #     ]

            #     final_assigned = [
            #         a for a in new_assigned if a in accessible_subdepartments
            #     ] + [a for a in current_assigned if a not in accessible_subdepartments]
            # else:
            #     # برای ایجاد کاربر جدید، فقط مقادیری که HR به آن‌ها دسترسی دارد قبول شود
            #     accessible_holdings = set(
            #         user.hr_accessible_holdings.all().values_list("id", flat=True)
            #     )
            #     accessible_factories = set(
            #         user.hr_accessible_factories.all().values_list("id", flat=True)
            #     )
            #     accessible_departments = set(
            #         user.hr_accessible_departments.all().values_list("id", flat=True)
            #     )
            #     accessible_subdepartments = set(
            #         user.hr_accessible_subdepartments.all().values_list("id", flat=True)
            #     )

            #     final_holdings = [h for h in new_holdings if h in accessible_holdings]
            #     final_factories = [
            #         f for f in new_factories if f in accessible_factories
            #     ]
            #     final_departments = [
            #         d for d in new_departments if d in accessible_departments
            #     ]
            #     final_supervising = [
            #         s for s in new_supervising if s in accessible_subdepartments
            #     ]
            #     final_assigned = [
            #         a for a in new_assigned if a in accessible_subdepartments
            #     ]

            # emp = {
            #     "national_id": data["national_id"],
            #     "personnel_code": data["personnel_code"],
            #     "first_name": data["first_name"],
            #     "last_name": data["last_name"],
            #     "phone_number": data["phone_number"],
            #     "email": data["email"],
            #     "password": hashed_password,
            #     "unlimit_reservation": data["unlimit_reservation"] if data["unlimit_reservation"] and data["unlimit_reservation"] not in ["" , None] else False,

            #     "managing_holdings": final_holdings,
            #     "managing_factories": final_factories,
            #     "managing_departments": final_departments,
            #     "supervising_subdepartments": final_supervising,
            #     "assigned_subdepartments": final_assigned,
            # }

            emp = {}
            for field, ftype in FIELD_DEFINITIONS.items():
                if ftype == "list":
                    continue
                if field in ["password", "confirm_password"]:
                    continue
                emp[field] = convert_value(field, data.get(field), ftype)

            emp["password"] = hashed_password

            # print(emp)

            if is_exist:
                update_permitted = request.POST.get("update_permitted") == "true"

                if not update_permitted:
                    return JsonResponse(
                        {
                            "status": "exists",
                            "message": "کاربر با این کد ملی وجود دارد. آیا مایل به بروزرسانی اطلاعات هستید؟",
                            "employee_name": f"{existing_emp.first_name} {existing_emp.last_name}",
                        }
                    )

                create_user(emp_info=emp)

            else:
                create_user(emp_info=emp)

            coresponding_user = Employee.objects.filter(national_id=data["national_id"])

            if is_exist:
                return JsonResponse(
                    {"status": "updated", "message": "کاربر با موفقیت بروزرسانی شد."}
                )
            else:
                return JsonResponse(
                    {"status": "created", "message": "کاربر جدید با موفقیت ایجاد شد."}
                )

    # total_count = employees.count()

    # if request.headers.get("X-Requested-With") == "XMLHttpRequest":
    #     offset = int(request.GET.get("offset", 0))

    #     employees_page = employees[offset:offset + LOAD_MORE_COUNT]

    #     context = {
    #         "employees": employees_page,
    #         "offset": offset,
    #     }

    #     return render(
    #         request,
    #         "users/user_management.html",
    #         context
    #     )

    # employees = employees[:INITIAL_LOAD_COUNT]

    # departments = user.hr_accessible_departments.all()
    # subdepartments = user.hr_accessible_subdepartments.all()

    # محاسبه is_super_admin
    context = {
        "form": form,
        "employees": employees,
        "user": user,
        "holdings": holdings,
        "factories": factories,
        "departments": departments,
        "subdepartments": subdepartments,
        # "initial_load_count": INITIAL_LOAD_COUNT,
        # "load_more_count": LOAD_MORE_COUNT,
        # "total_count": employees.count(),
    }

    return render(request, "users/user_management.html", context)


def create_user(emp_info, update_partial=True):
    """
    ایجاد یا بروزرسانی کاربر با کنترل بیشتر روی بروزرسانی

    Args:
        emp_info: دیکشنری شامل اطلاعات پرسنل
        update_partial: اگر True باشد، فقط فیلدهای ارسال شده آپدیت می‌شوند
                        اگر False باشد، فیلدهای ارسال نشده ریست می‌شوند

    Returns:
        Employee: شیء کارمند ایجاد یا بروزرسانی شده
    """

    # print(f"vvvvvvvvvvvvvvv {emp_info}")
    with transaction.atomic():
        national_id = emp_info.get("national_id")
        if not national_id:
            raise ValidationError("کد ملی الزامی است")

        # فیلدهای مستقیم مدل Employee
        employee_fields = [
            f.name
            for f in Employee._meta.get_fields()
            if not f.many_to_many and not f.one_to_many
        ]

        # نگاشتها (مثل قبل)
        field_mapping = {
            "managing_holdings": "managed_holdings_m2m",
            "managing_factories": "managed_factories_m2m",
            "managing_departments": "managed_departments_m2m",
            "supervising_subdepartments": "supervised_subdepartments_m2m",
            "assigned_subdepartments": "assigned_subdepartments",
        }

        field_model_mapping = {
            "managed_holdings_m2m": Holding,
            "managed_factories_m2m": Factory,
            "managed_departments_m2m": Department,
            "supervised_subdepartments_m2m": Subdepartment,
            "assigned_subdepartments": Subdepartment,
        }

        # جداسازی داده‌ها
        direct_data = {}
        many_to_many_data = {}

        for key, value in emp_info.items():
            if key in employee_fields and value is not None:
                direct_data[key] = value
            elif key in field_mapping:
                m2m_field = field_mapping[key]
                many_to_many_data[m2m_field] = value  # None هم معنی دارد

        # پیدا کردن یا ایجاد کاربر
        try:
            employee = Employee.objects.get(national_id=national_id)

            # بروزرسانی فیلدهای مستقیم
            for key, value in direct_data.items():
                setattr(employee, key, value)
            print(f"many_to_many_data : {many_to_many_data}")

            # بروزرسانی فیلدهای ManyToMany
            for m2m_field, items in many_to_many_data.items():
                if items is None:
                    # اگر None ارسال شده، این فیلد را آپدیت نکن (فقط در حالت update_partial=True)
                    if not update_partial:
                        getattr(employee, m2m_field).clear()
                elif isinstance(items, list):
                    model_class = field_model_mapping.get(m2m_field)
                    # print(f"model_class : {model_class}")
                    if model_class:
                        if items:  # لیست خالی نیست
                            objects = model_class.objects.filter(id__in=items)
                            getattr(employee, m2m_field).set(objects)
                        else:  # لیست خالی
                            getattr(employee, m2m_field).clear()

            employee.save()

        except ObjectDoesNotExist:
            # ایجاد کاربر جدید
            employee = Employee.objects.create(**direct_data)

            # اضافه کردن ارتباطات ManyToMany
            for m2m_field, items in many_to_many_data.items():
                if items and isinstance(items, list):
                    model_class = field_model_mapping.get(m2m_field)
                    if model_class:
                        objects = model_class.objects.filter(id__in=items)
                        if objects:
                            getattr(employee, m2m_field).add(*objects)

        return employee


# def create_user(emp_info, fields):

#     national_id = emp_info["national_id"]
#     # existing_emp = Employee.objects.filter(national_id=national_id).first()

#     defaults = {}
#     for field in fields:
#         value = emp_info.get(field)
#         if value not in [None, ""]:  # یعنی خالی ارسال نشده
#             defaults[field] = value

#     obj, created = Employee.objects.update_or_create(
#         national_id=national_id, defaults=defaults
#     )


#     return None


@login_required
def user_details(request, employee_id):
    employee = get_object_or_404(Employee, pk=employee_id)
    if request.user.role.name != "super_admin" and request.user != employee:
        raise PermissionDenied("شما اجازه مشاهده جزئیات این کارمند را ندارید.")
    form = UserDetailsFilterForm(request.GET or None)
    participations = Participation.objects.filter(user=employee)

    if form.is_valid():
        factory = form.cleaned_data.get("factory")
        department = form.cleaned_data.get("department")
        role = form.cleaned_data.get("role")
        search_title = form.cleaned_data.get("search_title")
        if factory:
            participations = participations.filter(user__factory=factory)
        if department:
            participations = participations.filter(user__department=department)
        if role:
            participations = participations.filter(user__role=role)
        if search_title:
            participations = participations.filter(
                Q(title__icontains=search_title)
                | Q(description__icontains=search_title)
            )

    print(
        f"User: {employee.full_name} (ID: {employee.id}), Participations count: {participations.count()}"
    )

    participation_counts = {
        item_type[0]: participations.filter(item_type=item_type[0]).count()
        for item_type in Participation.ITEM_TYPES
    }
    participation_display = [
        {"display": label, "count": participation_counts.get(key, 0), "audio_count": 0}
        for key, label in Participation.ITEM_TYPES
    ]
    audio_count = participations.filter(item_type="performance_file").count()
    other_count = participations.exclude(item_type="performance_file").count()

    chart_data = (
        json.dumps(list(participation_counts.values()))
        if participation_counts
        else json.dumps([0, 0, 0, 0, 0])
    )
    file_type_chart_data = chart_data

    return render(
        request,
        "users/user_details.html",
        {
            "employee": employee,
            "form": form,
            "participations": participations,
            "user": request.user,
            "participation_display": participation_display,
            "audio_count": audio_count,
            "other_count": other_count,
            "chart_data": chart_data,
            "file_type_chart_data": file_type_chart_data,
        },
    )


@login_required
def submit_participation(request):

    can_referral = True

    if request.method == "POST":
        form = ParticipationForm(request.POST, request.FILES, user=request.user)
        if form.is_valid():
            participation = form.save(commit=False)
            participation.user = request.user
            # تنظیم وضعیت اولیه بر اساس نقش

            role_name = request.session["current_role"]
            # holding_id = request.session['current_holding_id']
            # factory_id = request.session['current_factory_id']
            # department_id = request.session['current_department_id']
            # subdepartment_id = request.session['current_subdepartment_id']

            participation.role_name = role_name
            # participation.holding_id = holding_id
            # participation.factory_id = factory_id
            # participation.department_id = department_id
            # participation.subdepartment_id = subdepartment_id

            if participation.is_committee and participation.subdepartment:
                # کمیته: همه چیز از subdepartment
                sub = participation.subdepartment
                participation.subdepartment_committee = sub
                participation.department_committee = sub.department
                participation.factory_committee = sub.department.factory
                participation.holding_committee = (
                    sub.department.factory.holding
                )  # اگر holding نباشه None میشه

                # فیلدهای عادی رو از سشن می‌گذاریم (اختیاری، ولی برای یکپارچگی خوبه)
                participation.subdepartment_id = request.session.get(
                    "current_subdepartment_id"
                )
                participation.department_id = request.session.get(
                    "current_department_id"
                )
                participation.factory_id = request.session.get("current_factory_id")
                participation.holding_id = request.session.get("current_holding_id")

            else:
                # عادی: فقط از سشن پر می‌کنیم
                participation.subdepartment_id = request.session.get(
                    "current_subdepartment_id"
                )
                participation.department_id = request.session.get(
                    "current_department_id"
                )
                participation.factory_id = request.session.get("current_factory_id")
                participation.holding_id = request.session.get("current_holding_id")

                # اگر بخوای فیلدهای کمیته رو خالی کنی (تمیزتره)
                participation.subdepartment_committee = None
                participation.department_committee = None
                participation.factory_committee = None
                participation.holding_committee = None

            if participation.attachment:
                root, ext = os.path.splitext(participation.attachment.name.lower())
            if not participation.attachment or not (
                ext in security.audio or ext in security.video
            ):
                participation.text_content = participation.description
                participation.status = "user_review"
            else:
                participation.is_audio = True
                participation.status = "pending"

            participation.save()
            messages.success(request, "مشارکت با موفقیت ثبت شد.")
            # return redirect("users:dashboard")
            return redirect("users:process_participation", participation.id)

    else:
        form = ParticipationForm(user=request.user)
    return render(request, "users/submit_participation.html", {"form": form})


@login_required
def evaluation_panel(request):
    user_role = request.user.roles.values_list("name", flat=True)
    if not any(role in ["super_admin", "department_manager"] for role in user_role):
        raise PermissionDenied("شما اجازه دسترسی به پنل ارزیابی را ندارید.")

    form = EvaluationFilterForm(request.GET or None)
    evaluations = Evaluation.objects.all()

    # فیلتر اولیه بر اساس نقش
    if "super_admin" in user_role:
        evaluations = Evaluation.objects.all()
    elif "department_manager" in user_role:
        managed_department = Department.objects.filter(managers=request.user).first()
        evaluations = (
            Evaluation.objects.filter(user__department=managed_department)
            if managed_department
            else Evaluation.objects.none()
        )

    if form.is_valid():
        period = form.cleaned_data.get("period")
        factory = form.cleaned_data.get("factory")
        department = form.cleaned_data.get("department")
        employee = form.cleaned_data.get("employee")
        start_date = form.cleaned_data.get("start_date")
        end_date = form.cleaned_data.get("end_date")
        if period:
            if period == "custom":
                if start_date and end_date:
                    evaluations = evaluations.filter(
                        created_at__range=(start_date, end_date)
                    )
            else:
                evaluations = evaluations.filter(period=period)
        if factory:
            evaluations = evaluations.filter(user__factory=factory)
        if department:
            evaluations = evaluations.filter(user__department=department)
        if employee:
            evaluations = evaluations.filter(user=employee)

    print(f"Number of evaluations after filter: {evaluations.count()}")

    progress_data = {}
    for eval in evaluations:
        total_participations = Participation.objects.filter(user=eval.user).count()
        period_participations = Participation.objects.filter(
            user=eval.user,
            created_at__range=(
                (
                    eval.created_at.replace(day=1),
                    eval.created_at.replace(day=28) + timedelta(days=3),
                )
                if eval.period == "monthly"
                else (
                    (eval.created_at - timedelta(days=7), eval.created_at)
                    if eval.period == "weekly"
                    else (
                        (eval.created_at, eval.created_at + timedelta(days=1))
                        if eval.period == "daily"
                        else (eval.created_at, eval.created_at)
                    )
                )
            ),
        ).count()
        progress = (
            (period_participations / total_participations * 100)
            if total_participations > 0
            else 0
        )
        progress_data[eval.id] = {
            "user": eval.user.full_name,
            "period": eval.get_period_display(),
            "participation_count": period_participations,
            "progress": round(progress, 2),
        }

    chart_data = (
        json.dumps(
            [
                progress_data[eval.id]["progress"]
                for eval in evaluations.order_by("-created_at")[:5]
            ]
        )
        if evaluations.exists()
        else json.dumps([0, 0, 0, 0, 0])
    )

    return render(
        request,
        "users/evaluation_panel.html",
        {
            "form": form,
            "evaluations": evaluations,
            "progress_data": progress_data,
            "chart_data": chart_data,
            "user": request.user,
        },
    )


@login_required
def process_participation(request, participation_id):

    participation = get_object_or_404(Participation, pk=participation_id)

    user_role = request.user.roles.values_list("name", flat=True)
    # if not any(role in ['super_admin', 'factory_manager', 'department_manager', 'supervisor'] for role in user_role):

    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    participation_is_committee = participation.is_committee
    real_role = request.session["current_real_role"]

    if participation.user != request.user and role_name not in [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]:
        raise PermissionDenied("شما اجازه دسترسی به این مشارکت را ندارید.")

    # if participation.user != request.user and role_name not in ['super_admin', 'factory_manager', 'department_manager', 'supervisor']:
    # print(role_name)
    if participation.user != request.user and not role_name in [
        "super_admin",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]:
        raise PermissionDenied("شما اجازه دسترسی به این مشارکت را ندارید.")

    if request.method == "POST":
        action = request.POST.get("action")

        if (
            action == "convert_to_text"
            and participation.status == "pending"
            and participation.attachment
            and (
                participation.attachment.name.lower().endswith(".mp3")
                or participation.attachment.name.lower().endswith(".mp4")
            )
            and not participation.text_content
        ):
            try:
                file_path = participation.attachment.path

                if os.path.exists(file_path):
                    temp_wav_path = file_path.rsplit(".", 1)[0] + "_temp.wav"
                    text = STT_full_file(file_path, temp_wav_path, 10)

                    participation.text_content = text
                    participation.orginal_content = text
                    user_role = request.user.roles.values_list("name", flat=True)

                    participation.status = "user_review"

                    # if "employee" in user_role:
                    #     participation.status = "user_review"
                    # elif "supervisor" in user_role:
                    #     participation.status = "user_review"  # سرپرست خودش تأیید می‌کنه
                    # elif "department_manager" in user_role:
                    #     participation.status = (
                    #         "user_review"  # مدیر بخش خودش تأیید می‌کنه
                    #     )
                    # elif "factory_manager" in user_role:
                    #     participation.status = (
                    #         "user_review"  # مدیر کارخانه خودش تأیید می‌کنه
                    #     )
                    # elif "super_admin" in user_role:
                    #     participation.status = "user_review"  # مدیر کل خودش تأیید می‌کنه

                    participation.save()
                    messages.success(request, "متن با موفقیت استخراج شد.")
                    if os.path.exists(temp_wav_path):
                        os.remove(temp_wav_path)
                    return redirect("users:process_participation", participation.id)
                else:
                    messages.error(request, f"فایل یافت نشد: {file_path}")
            except sr.UnknownValueError:
                messages.error(request, "نمی‌توانم صوت را بفهمم.")
            except sr.RequestError as e:
                messages.error(request, f"خطا در سرویس تشخیص: {str(e)}")
            except (ConnectionError, TimeoutError) as e:
                messages.error(
                    request,
                    "درحال حاظر به علت مشکلات اینترنت، قادر به انجام عملیات تبدیل ویس به متن نیستیم.",
                )
                participation.text_content = participation.description
                participation.status = "user_review"
                participation.save()
                return redirect("users:process_participation", participation.id)

            except Exception as e:
                messages.error(request, f"خطا در پردازش: {str(e)}")

        elif (
            action == "delete"
            and (
                participation.status == "user_review"
                or participation.status == "pending"
            )
            and not participation.is_finalized
            and participation.user == request.user
        ):
            try:
                if participation.attachment:
                    # 1. گرفتن مسیر کامل فایل در سیستم
                    file_path = participation.attachment.path

                    # 2. بررسی وجود فایل در سیستم قبل از حذف
                    if os.path.exists(file_path):
                        try:
                            os.remove(file_path)
                            # در اینجا می‌توان یک پیام log یا debug اضافه کرد
                        except Exception as e:
                            # اگر فایل حذف نشد، باید یک اخطار به کاربر داده شود (اختیاری)
                            messages.error(
                                request, f"اخطار: فایل ضمیمه حذف نشد. {str(e)}"
                            )

                participation.delete()
                messages.success(request, "مشارکت با موفقیت حذف شد.")
                # هدایت به داشبورد پس از حذف موفق
                # return redirect("users:dashboard")
                return redirect("users:landing")
            except Exception as e:
                messages.error(request, f"خطا در حذف مشارکت: {str(e)}")

        elif (
            action == "edit_text"
            and participation.status == "user_review"
            and not participation.is_finalized
            and participation.user == request.user
        ):
            raw_text = request.POST.get("text_content", "")

            try:
                # این خط مهم‌ترین خط امنیتی پروژه‌اته!
                cleaned_text = clean_user_text(raw_text)
            except SuspiciousOperation:
                messages.error(request, "متن وارد شده شامل کد مخرب است و رد شد.")
                return redirect("users:process_participation", participation_id)

            text = cleaned_text
            if text:
                participation.text_content = text
                participation.save()
                messages.success(request, "متن با موفقیت ویرایش شد.")

        elif (
            action == "finalize_text"
            and participation.status == "user_review"
            and not participation.is_finalized
            and participation.user == request.user
        ):
            participation.is_finalized = True
            raw_text = request.POST.get("text_content", "")

            try:
                # این خط مهم‌ترین خط امنیتی پروژه‌اته!
                cleaned_text = clean_user_text(raw_text)
            except SuspiciousOperation:
                messages.error(request, "متن وارد شده شامل کد مخرب است و رد شد.")
                return redirect("users:process_participation", participation_id)

            text = cleaned_text
            if text:
                participation.text_content = text
                participation.save()
                messages.success(request, "مشارکت تایید شد.")

            # MARK: send paricipation to next level needs to check (supervisor --> supervisors)

            # also: management todo
            if "employee" in role_name:
                subdepartment_supervisor = None
                if subdepartment_id and subdepartment_id != None:
                    subdepartment_supervisor = (
                        Subdepartment.objects.filter(id=subdepartment_id)
                        .first()
                        .supervisor
                    )
                # MARK: management todo end

                if subdepartment_supervisor and subdepartment_supervisor != None:
                    participation.status = "supervisor_review"
                else:
                    participation.status = "manager_review"

            elif "supervisor" in role_name:
                if participation_is_committee:
                    participation.status = "supervisor_review"
                else:
                    participation.status = "manager_review"
            elif "department_manager" in role_name:
                if participation_is_committee:
                    participation.status = "supervisor_review"
                else:
                    participation.status = "approved"  # مدیر بخش مستقیم تأیید می‌کنه
            elif "factory_manager" in role_name:
                participation.status = "approved"  # مدیر کارخانه مستقیم تأیید می‌کنه
            elif "holding_manager" in role_name:
                participation.status = "approved"
            elif "super_admin" in role_name:
                participation.status = "approved"  # مدیر کل مستقیم تأیید می‌کنه
            participation.save()
            messages.success(request, "مشارکت تایید نهایی شد، با تشکر از همکاری شما.")

            return redirect("users:dashboard")

        elif (
            action == "summarized_text"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
        ):

            def summarizing(text):
                summarized_text = summarizer(text)
                return summarized_text

            if not participation.count_sumerized:
                participation.count_sumerized = 0

            if participation.count_sumerized >= 2:

                participation.text_content = participation.summarized_content
                participation.save()
                messages.success(
                    request,
                    "متن خلاصه شده قبلی، محدودیت استفاده از خلاصه سازی شما برای این مشارکت تمام شده است.",
                )
            else:
                try:
                    summarized_text = summarizing(participation.text_content)
                    participation.summarized_content = summarized_text
                    participation.text_content = summarized_text
                    participation.count_sumerized += 1
                    participation.save()
                    messages.success(request, "متن با موفقیت خلاصه شد.")
                except Exception as e:
                    messages.error(
                        request,
                        f"خطا در خلاصه سازی متن: به علت مشکلات اینترنت ، خلاصه سازی متن مقدور نمی باشد.",
                    )

        elif (
            action == "normal_text"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
        ):
            participation.text_content = participation.orginal_content
            participation.save()
            messages.success(request, "متن اصلی.")

        return redirect(request.path_info)

    if request.method == "GET" and participation.status == "approved":
        action = request.GET.get("action")
        if (
            action == "download_text"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
        ):
            response = HttpResponse(
                participation.text_content, content_type="text/plain"
            )
            response["Content-Disposition"] = (
                f'attachment; filename="{participation.title}_text.txt"'
            )
            return response
        elif (
            action == "download_pdf"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
        ):

            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            safe_filename = f"Participation_{participation.id}_{timestamp}.pdf"

            pdf_buffer = save_as_pdf(text=participation.text_content)

            response = HttpResponse(
                pdf_buffer.getvalue(), content_type="application/pdf"
            )

            # تنظیم هدر برای دانلود
            response["Content-Disposition"] = f'attachment; filename="{safe_filename}"'

            # 4. بستن حافظه موقت
            pdf_buffer.close()

            return response

        elif (
            action == "download_word"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
        ):

            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            safe_filename = f"Participation_{participation.id}_{timestamp}.docx"

            word_buffer = save_as_word(
                text=participation.text_content,
                # filename=safe_filename,  # این پارامتر در تابع جدید ضروری نیست اما برای خوانایی می‌ماند
                title=participation.title,
            )

            response = HttpResponse(
                word_buffer.getvalue(),  # گرفتن داده‌های باینری از BytesIO
                content_type="application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            )

            # تنظیم هدر برای دانلود به جای نمایش در مرورگر
            response["Content-Disposition"] = f'attachment; filename="{safe_filename}"'

            word_buffer.close()

            return response

        elif (
            action == "download_mp3"
            and participation.text_content
            and (
                participation.user == request.user
                or role_name in ["super_admin", "factory_manager", "department_manager"]
            )
            and participation.attachment
        ):
            file_path = participation.attachment.path
            file_name = os.path.basename(file_path)
            print(file_path)
            print(file_name)
            if os.path.exists(file_path):
                try:
                    response = FileResponse(
                        open(file_path, "rb"),
                        as_attachment=True,
                        filename=os.path.basename(file_path),
                    )
                    return response
                except Exception as e:
                    messages.error(request, f"خطا در ارسال فایل: {str(e)}")
            else:
                messages.error(request, "فایل مورد نظر در سرور موجود نیست.")

    can_convert = (
        participation.status == "pending"
        and participation.attachment
        and (
            participation.attachment.name.lower().endswith(".mp3")
            or participation.attachment.name.lower().endswith(".mp4")
        )
        and not participation.text_content
        and participation.user == request.user
    )

    can_edit = (
        participation.status == "user_review"
        and not participation.is_finalized
        and participation.user == request.user
        and role_name == participation.role_name
    )
    can_finalize = (
        participation.status == "user_review"
        and not participation.is_finalized
        and participation.user == request.user
        and role_name == participation.role_name
    )
    can_summarize = (
        participation.status == "user_review"
        and not participation.is_finalized
        and participation.user == request.user
        and role_name == participation.role_name
    )

    can_delete = (
        (participation.status == "user_review" or participation.status == "pending")
        and not participation.is_finalized
        and participation.user == request.user
        and role_name == participation.role_name
    )

    can_download = (
        participation.status == "approved"
        and participation.is_finalized
        and (
            participation.user == request.user
            or role_name
            in [
                "super_admin",
                "holding_manager",
                "factory_manager",
                "department_manager",
                "supervisor",
            ]
        )
    )

    can_referral = participation.status == "approved"

    return render(
        request,
        "users/participation_detail.html",
        {
            "participation": participation,
            "can_convert": can_convert,
            "can_edit": can_edit,
            "can_finalize": can_finalize,
            "can_summarize": can_summarize,
            "can_delete": can_delete,
            "can_download": can_download,
            "can_referral": can_referral,
        },
    )


@login_required
def search_org_units(request):
    q = request.GET.get("q", "").strip()
    if len(q) < 2:
        return JsonResponse([], safe=False)

    results = []

    employees = (
        Employee.objects.filter(assigned_subdepartments__isnull=False)
        .filter(
            Q(first_name__icontains=q)
            | Q(last_name__icontains=q)
            | Q(national_id__icontains=q)
        )
        .distinct()[:10]
    )

    print(f"employee : {employees}")

    for e in employees:
        # گرفتن اولین زیربخش برای نمایش (اگر چند تا باشه)
        subdept = e.assigned_subdepartments.first()
        subdept_name = subdept.name if subdept else "نامشخص"
        dept_name = subdept.department.name if subdept else "نامشخص"
        factory_name = subdept.department.factory.name if subdept else "نامشخص"

        manager_name = e.get_full_name()
        results.append(
            {
                "id": e.id,
                "text": subdept.name,
                "factory": factory_name,
                "department": dept_name,
                "subdepartment": subdept_name,
                "content_type": ContentType.objects.get_for_model(Employee).id,
                "role": "employee",
                "role_display": "پرسنل",
                "manager_name": manager_name,
                "manager_search": manager_name.lower(),
            }
        )

    super_admin_role = Role.objects.filter(name="super_admin").first()
    if super_admin_role:
        admins = Employee.objects.filter(
            Q(roles=super_admin_role)
            & (
                Q(first_name__icontains=q)
                | Q(last_name__icontains=q)
                | Q(national_id__icontains=q)
            )
        ).distinct()

        for admin in admins:
            results.append(
                {
                    "id": admin.id,
                    "text": f"مدیر کل: {admin.get_full_name()}",
                    "content_type": ContentType.objects.get_for_model(
                        Employee
                    ).id,  # یا یه مدل جدا برای سیستم
                    "role": "super_admin",
                    "role_display": "مدیر کل",
                    "manager_name": admin.get_full_name(),
                    "manager_search": admin.get_full_name().lower(),
                    "is_system": True,  # برای تشخیص در فرانت‌اند
                }
            )

    # MARK: management todo
    # also: manager --> managers

    # هلدینگ‌ها
    holdings = Holding.objects.filter(
        Q(name__icontains=q)
        | Q(manager__first_name__icontains=q)
        | Q(manager__last_name__icontains=q)
    ).distinct()[:10]

    for h in holdings:
        manager_name = h.manager.get_full_name() if h.manager else "تعیین نشده"
        results.append(
            {
                "id": h.id,
                "text": h.name,
                "content_type": ContentType.objects.get_for_model(Holding).id,
                "role": "holding_manager",
                "role_display": "مدیر هلدینگ",
                "manager_name": manager_name,
                "manager_search": manager_name.lower(),  # برای جستجو
            }
        )

    # کارخانه‌ها
    factories = Factory.objects.filter(
        Q(name__icontains=q)
        | Q(manager__first_name__icontains=q)
        | Q(manager__last_name__icontains=q)
    ).distinct()[:10]

    for f in factories:
        manager_name = f.manager.get_full_name() if f.manager else "تعیین نشده"
        results.append(
            {
                "id": f.id,
                "text": f.name,
                "factory": f.name,
                "content_type": ContentType.objects.get_for_model(Factory).id,
                "role": "factory_manager",
                "role_display": "مدیر کارخانه",
                "manager_name": manager_name,
                "manager_search": manager_name.lower(),
            }
        )

    # بخش‌ها
    departments = Department.objects.filter(
        Q(name__icontains=q)
        | Q(manager__first_name__icontains=q)
        | Q(manager__last_name__icontains=q)
    ).distinct()[:10]

    for d in departments:
        manager_name = d.manager.get_full_name() if d.manager else "تعیین نشده"

        results.append(
            {
                "id": d.id,
                "text": d.name,
                "factory": d.factory.name,
                "department": d.name,
                "content_type": ContentType.objects.get_for_model(Department).id,
                "role": "department_manager",
                "role_display": "مدیر بخش",
                "manager_name": manager_name,
                "manager_search": manager_name.lower(),
            }
        )

    # زیربخش‌ها
    subdepartments = Subdepartment.objects.filter(
        Q(name__icontains=q)
        | Q(supervisor__first_name__icontains=q)
        | Q(supervisor__last_name__icontains=q)
    ).distinct()[:10]

    for s in subdepartments:
        manager_name = s.supervisor.get_full_name() if s.supervisor else "تعیین نشده"
        results.append(
            {
                "id": s.id,
                "text": s.name,
                "factory": s.department.factory.name,
                "department": s.department.name,
                "subdepartment": s.name,
                "content_type": ContentType.objects.get_for_model(Subdepartment).id,
                "role": "supervisor",
                "role_display": "سرپرست",
                "manager_name": manager_name,
                "manager_search": manager_name.lower(),
            }
        )
    # MARK: management todo end

    # محدود کردن نتایج کلی
    return JsonResponse(results[:25], safe=False)


@login_required
def referral_create(request, participation_id):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    real_role = request.session["current_real_role"]

    participation = get_object_or_404(Participation, id=participation_id)
    participation_is_committee = participation.is_committee

    # چک وضعیت مشارکت
    if participation.status != "approved":
        messages.error(request, "فقط مشارکت‌های تأیید شده قابل ارجاع هستند.")
        return redirect("users:participation_detail", participation_id)

    current_role_name = request.session.get("current_role", "employee")
    # if current_role_name == 'employee':
    #     messages.error(request, "شما اجازه ارجاع ندارید.")
    #     return redirect('users:participation_detail', participation_id)

    current_user = request.user
    # current_role = role_name
    current_role = Role.objects.get(name=current_role_name)

    if request.method == "POST":
        title = request.POST.get("title", "").strip()
        comment = request.POST.get("comment", "").strip()
        
        target_object_id = request.POST.get("target_object_id")
        target_content_type_id = request.POST.get("target_content_type")

        if not all([title, comment, target_object_id, target_content_type_id]):
            messages.error(request, "همه فیلدها الزامی هستند.")
            return render(
                request, "users/referral_create.html", {"participation": participation}
            )

        try:
            with transaction.atomic():
                content_type = ContentType.objects.get_for_id(target_content_type_id)
                target_object = content_type.get_object_for_this_type(
                    id=target_object_id
                )

                # پیدا کردن مسئول مقصد (Employee)
                if content_type.model == "employee":
                    to_user = target_object

                # MARK: management todo
                elif hasattr(target_object, "manager") and target_object.manager:
                    to_user = target_object.manager
                elif hasattr(target_object, "supervisor") and target_object.supervisor:
                    to_user = target_object.supervisor
                # MARK: management todo end
                else:
                    messages.error(request, "این واحد مسئول مشخصی ندارد.")
                    return render(
                        request,
                        "users/referral_create.html",
                        {"participation": participation},
                    )

                # ساخت یا گرفتن OrgUnit مقصد (بدون تکرار!)
                unit_kwargs = {"unit_type": content_type.model}

                if content_type.model != "employee":
                    unit_kwargs[content_type.model] = target_object
                else:
                    unit_kwargs["unit_type"] = "system"

                final_unit, created = OrgUnit.objects.get_or_create(
                    **unit_kwargs, defaults=unit_kwargs
                )

                # ساخت یا گرفتن OrgUnit مبدا (کاربر فعلی)
                created_by_unit_kwargs = {}
                if current_role_name == "super_admin":
                    created_by_unit_kwargs = {"unit_type": "system"}

                elif current_role_name == "employee":

                    subdepartment_id = request.session.get("current_subdepartment_id")
                    created_by_unit_kwargs = {
                        "unit_type": "employee",
                        "subdepartment_id": subdepartment_id,
                    }

                    print(subdepartment_id)
                    print(created_by_unit_kwargs)

                else:
                    holding_id = request.session.get("current_holding_id")
                    factory_id = request.session.get("current_factory_id")
                    department_id = request.session.get("current_department_id")
                    subdepartment_id = request.session.get("current_subdepartment_id")

                    print(f"****{subdepartment_id}")
                    print(f"***{department_id}")
                    print(f"**{factory_id}")
                    print(f"*{holding_id}")

                    if subdepartment_id:
                        created_by_unit_kwargs = {
                            "unit_type": "subdepartment",
                            "subdepartment_id": subdepartment_id,
                        }
                    elif department_id:
                        created_by_unit_kwargs = {
                            "unit_type": "department",
                            "department_id": department_id,
                        }
                    elif factory_id:
                        created_by_unit_kwargs = {
                            "unit_type": "factory",
                            "factory_id": factory_id,
                        }
                    elif holding_id:
                        created_by_unit_kwargs = {
                            "unit_type": "holding",
                            "holding_id": holding_id,
                        }

                    # print(created_by_unit_kwargs)

                if not created_by_unit_kwargs:
                    raise ValueError("واحد سازمانی مبدا مشخص نیست.")

                created_by_unit, _ = OrgUnit.objects.get_or_create(
                    **created_by_unit_kwargs, defaults=created_by_unit_kwargs
                )

                # ساخت Referral
                referral = Referral.objects.create(
                    title=title,
                    description=comment,
                    participation=participation,
                    created_by_unit=created_by_unit,
                    created_by_role=current_role,
                    created_by_user=current_user,
                    final_unit=final_unit,
                )

                # تعیین نقش مقصد
                role_map = {
                    "holding": "holding_manager",
                    "factory": "factory_manager",
                    "department": "department_manager",
                    "subdepartment": "supervisor",
                    "employee": "super_admin",
                }
                to_role_name = role_map.get(content_type.model, "employee")
                to_role = Role.objects.get(name=to_role_name)

                # ساخت اولین مرحله
                ReferralStep.objects.create(
                    referral=referral,
                    from_unit=created_by_unit,
                    to_unit=final_unit,
                    from_role=current_role,
                    to_role=to_role,
                    from_user=current_user,
                    to_user=to_user,
                    comment=comment,
                    order=1,
                    is_approved=None,
                )

            messages.success(
                request, f"ارجاع با موفقیت به {to_user.get_full_name()} ارسال شد."
            )
            # return redirect("users:dashboard")
            return redirect("users:landing")

        except Exception as e:
            messages.error(request, f"خطا در ایجاد ارجاع: {str(e)}")
            return render(
                request, "users/referral_create.html", {"participation": participation}
            )

    return render(
        request, "users/referral_create.html", {"participation": participation}
    )


@login_required
def referrals_inbox(request):
    current_user = request.user
    current_role_name = request.session.get("current_role", "employee")

    # ۱. پیدا کردن تمام OrgUnitهایی که این کاربر الان مسئولشونه (بر اساس نقش فعلی)
    current_units = []

    if current_role_name == "super_admin":
        # مدیر کل: همه ارجاعات رو می‌بینه؟ یا فقط اونایی که مستقیم بهش ارسال شده؟
        # فعلاً فرض: فقط اونایی که to_user = خودش باشه
        current_units = OrgUnit.objects.filter(unit_type="system")

    elif current_role_name == "holding_manager":
        holding_id = request.session.get("current_holding_id")
        if holding_id:
            current_units = OrgUnit.objects.filter(
                unit_type="holding", holding_id=holding_id
            )

    elif current_role_name == "factory_manager":
        factory_id = request.session.get("current_factory_id")
        if factory_id:
            current_units = OrgUnit.objects.filter(
                unit_type="factory", factory_id=factory_id
            )

    elif current_role_name == "department_manager":
        department_id = request.session.get("current_department_id")
        if department_id:
            current_units = OrgUnit.objects.filter(
                unit_type="department", department_id=department_id
            )

    elif current_role_name == "supervisor":
        subdepartment_id = request.session.get("current_subdepartment_id")
        if subdepartment_id:
            current_units = OrgUnit.objects.filter(
                unit_type="subdepartment", subdepartment_id=subdepartment_id
            )

    elif current_role_name == "employee":
        subdepartment_id = request.session.get("current_subdepartment_id")
        if subdepartment_id:
            current_units = OrgUnit.objects.filter(
                unit_type="employee", subdepartment_id=subdepartment_id
            )

    # ۲. پیدا کردن تمام ReferralStepهایی که to_unit یکی از current_units هست
    steps = (
        ReferralStep.objects.filter(
            Q(from_unit__in=current_units) | Q(to_unit__in=current_units)
        )
        .select_related(
            "referral",
            "referral__participation",
            "from_user",
            "to_user",
            "from_role",
            "to_role",
        )
        .order_by("-created_at")
    )

    # ۳. استخراج Referralهای یکتا + اطلاعات وضعیت فعلی
    referrals = []
    seen_referral_ids = set()

    for step in steps:
        if step.referral.id in seen_referral_ids:
            continue

        seen_referral_ids.add(step.referral.id)

        # آیا این مرحله فعلی نوبت کاربر است؟
        is_my_turn = (
            step.to_unit in current_units
            and step.to_user == current_user
            and step.is_approved is None
        )

        # آیا من فرستنده این مرحله بودم؟
        is_sent_by_me = (
            step.from_unit in current_units and step.from_user == current_user
        )

        referrals.append(
            {
                "referral": step.referral,
                "current_step": step,
                "is_my_turn": is_my_turn,
                "is_sent_by_me": is_sent_by_me,
                "total_steps": step.referral.steps.count(),
                "latest_step": step,  # آخرین مرحله این ارجاع
            }
        )

    # ۴. صفحه‌بندی
    paginator = Paginator(referrals, 15)
    page_number = request.GET.get("page")
    page_obj = paginator.get_page(page_number)

    context = {
        "page_obj": page_obj,
        "total_referrals": len(referrals),
        "current_role_display": dict(Role._meta.get_field("name").flatchoices).get(
            current_role_name, current_role_name
        ),
    }
    return render(request, "users/referrals_inbox.html", context)


@login_required
def referral_detail(request, referral_id):
    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    user = request.user
    management_tree = request.session.get("management_tree", [])
    is_committee = request.session["current_is_committee"]
    real_role_name = request.GET.get("current_real_role")

    referral = get_object_or_404(Referral, id=referral_id)

    # تمام مراحل این ارجاع
    steps = referral.steps.select_related(
        "from_user", "to_user", "from_role", "to_role", "from_unit", "to_unit"
    ).order_by("order")

    # آیا کاربر فعلی در این ارجاع دخیل است؟
    current_user = user
    user_involved = steps.filter(
        Q(from_user=current_user) | Q(to_user=current_user)
    ).exists()

    # آخرین مرحله (برای نمایش وضعیت فعلی)
    latest_step = steps.last()

    # Set can_proceed flag based on referral conditions
    # can_proceed = True if latest_step.is_approved is None else False

    if not latest_step:
        can_proceed = False

    else:
        if role_name == "employee":
            can_proceed = (
                latest_step.to_unit.unit_type == "employee"
                and latest_step.to_unit.subdepartment_id == int(subdepartment_id)
            )

        elif role_name == "supervisor":
            can_proceed = (
                latest_step.to_unit.unit_type == "subdepartment"
                and latest_step.to_unit.subdepartment_id == int(subdepartment_id)
            )

        elif role_name == "dapartment_manager":
            can_proceed = (
                latest_step.to_unit.unit_type == "department"
                and latest_step.to_unit.department_id == int(department_id)
            )

        elif role_name == "factory_manager":
            can_proceed = (
                latest_step.to_unit.unit_type == "factory"
                and latest_step.to_unit.factory_id == int(factory_id)
            )

        elif role_name == "holding_manager":
            can_proceed = (
                latest_step.to_unit.unit_type == "holding"
                and latest_step.to_unit.holding_id == int(holding_id)
            )

        elif role_name == "super_admin":
            can_proceed = latest_step.to_unit.unit_type == "system"

    # Handle user actions (approve or re-refer)
    if request.method == "POST":
        action = request.POST.get("action")  # 'approve' or 're_refer'
        comment = request.POST.get("comment")

        if action == "approve":
            # Update referral step with approval and save comment
            latest_step.is_approved = True
            latest_step.comment = comment
            latest_step.save()
            return redirect("users:referrals_inbox")  # Redirect after approval

        elif action == "re_refer":
            comment = request.POST.get("comment")
            if not comment:
                messages.error(request, "لطفاً توضیحات ارجاع مجدد را وارد کنید.")
                return redirect("users:referral_detail", referral_id=referral.id)

            target_object_id = request.POST.get("target_object_id")
            target_content_type_id = request.POST.get("target_content_type")

            if not target_object_id or not target_content_type_id:
                messages.error(request, "واحد مقصد انتخاب نشده است.")
                return redirect("users:referral_detail", referral_id=referral.id)
            try:
                content_type = ContentType.objects.get_for_id(target_content_type_id)
                target_object = content_type.get_object_for_this_type(
                    id=target_object_id
                )
            except (ContentType.DoesNotExist, content_type.model_class().DoesNotExist):
                messages.error(request, "واحد مقصد معتبر نیست.")
                return redirect("users:referral_detail", referral_id=referral.id)

            # تعیین to_user (مسئول واحد مقصد)
            # MARK: management todo
            if hasattr(target_object, "manager"):
                to_user = target_object.manager  # برای Holding, Factory, Department
            elif hasattr(target_object, "supervisor"):
                to_user = target_object.supervisor  # برای Subdepartment
            # MARK: management todo end
            else:
                messages.error(request, "این واحد مسئول مشخصی ندارد.")
                return redirect("users:referral_detail", referral_id=referral.id)

            if not to_user:
                messages.error(request, "مسئول این واحد تعیین نشده است.")
                return redirect("users:referral_detail", referral_id=referral.id)

            # تعیین نقش مقصد بر اساس نوع واحد
            role_map = {
                "holding": "holding_manager",
                "factory": "factory_manager",
                "department": "department_manager",
                "subdepartment": "supervisor",
                "employee": "employee",
            }
            unit_type = content_type.model  # مثلاً 'holding', 'factory', ...
            to_role_name = role_map.get(unit_type)

            if not to_role_name:
                messages.error(request, "نقش مقصد قابل تشخیص نیست.")
                return redirect("users:referral_detail", referral_id=referral.id)

            to_role = get_object_or_404(Role, name=to_role_name)

            # ایجاد OrgUnit برای مقصد
            to_org_unit = OrgUnit.objects.get_or_create(
                unit_type=unit_type,
                holding_id=getattr(target_object, "holding_id", None)
                or (target_object.id if unit_type == "holding" else None),
                factory_id=getattr(target_object, "factory_id", None)
                or (target_object.id if unit_type == "factory" else None),
                department_id=getattr(target_object, "department_id", None)
                or (target_object.id if unit_type == "department" else None),
                subdepartment_id=getattr(target_object, "subdepartment_id", None)
                or (target_object.id if unit_type == "subdepartment" else None),
            )[
                0
            ]  # get_or_create برمی‌گرداند (object, created)

            # OrgUnit فرستنده فعلی (از latest_step استفاده کن)
            from_org_unit = (
                latest_step.from_unit
            )  # یا to_unit؟ بسته به منطق — معمولاً to_unit فعلی میشه from_unit جدید
            from_role = latest_step.from_role  # نقش فعلی کاربر

            # ایجاد مرحله جدید ارجاع
            new_step = ReferralStep.objects.create(
                referral=referral,
                from_unit=latest_step.to_unit,  # واحد فعلی (که کاربر الان توشه) میشه فرستنده جدید
                to_unit=to_org_unit,  # واحد جدید مقصد
                from_role=latest_step.to_role,  # نقش فعلی کاربر
                to_role=to_role,  # نقش مقصد
                from_user=current_user,  # کاربر فعلی
                to_user=to_user,  # مسئول واحد جدید
                comment=comment,
                order=latest_step.order + 1,
                is_approved=None,  # در انتظار اقدام
            )

            messages.success(
                request,
                f"ارجاع با موفقیت به {to_org_unit.get_display_name()} ارسال شد.",
            )
            return redirect("users:referrals_inbox")

    context = {
        "referral": referral,
        "participation": referral.participation,
        "steps": steps,
        "latest_step": latest_step,
        "user_involved": user_involved,
        "total_steps": steps.count(),
        "can_proceed": can_proceed,
    }
    return render(request, "users/referral_detail.html", context)


@login_required
def review_participation(request, participation_id):

    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    is_committee = request.session["current_is_committee"]
    real_role = request.session["current_real_role"]

    participation = get_object_or_404(Participation, pk=participation_id)
    # user_role = list(request.user.roles.values_list('name', flat=True))[0]
    allowed_roles = {
        "supervisor_review": "supervisor",
        "manager_review": "department_manager",
    }

    left_manager_review = []
    if not participation.manager_status:
        left_manager_review.append("department_manager")
    if not participation.manager_2_status:
        left_manager_review.append("department_manager_2")
    if not participation.manager_3_status:
        left_manager_review.append("department_manager_3")

    # if (participation.status not in allowed_roles or role_name != allowed_roles[participation.status]):
    #     raise PermissionDenied("شما اجازه بررسی این مشارکت را ندارید.")

    if request.method == "POST":
        action = request.POST.get("action")
        if action == "approve":

            if participation.status == "supervisor_review":
                if is_committee:
                    participation.status = "factory_manager_review"
                    participation.supervisor_status = "approved"
                else:
                    participation.status = "manager_review"

            elif participation.status == "manager_review":

                # if real_role == 'department_manager':
                #
                # elif real_role == 'department_manager_2':
                # elif real_role == 'department_manager_3':

                if is_committee:
                    # MARK: management in committee todo
                    # MARK: here
                    if real_role in left_manager_review:
                        if real_role == "department_manager":
                            participation.manager_status = "approved"
                        elif real_role == "department_manager_2":
                            participation.manager_2_status = "approved"
                        elif real_role == "department_manager_3":
                            participation.manager_3_status = "approved"

                        participation.save()

                        left_manager_review = []
                        if not participation.manager_status:
                            left_manager_review.append("department_manager")
                        if not participation.manager_2_status:
                            left_manager_review.append("department_manager_2")
                        if not participation.manager_3_status:
                            left_manager_review.append("department_manager_3")

                        if not left_manager_review and is_committee:
                            participation.status = "factory_manager_review"
                            participation.save()
                else:
                    participation.status = "approved"
                    participation.save()

            elif participation.status == "factory_manager_review":
                participation.status = "approved"
                participation.save()

            # MARK: management todo end

            participation.save()
            messages.success(request, "مشارکت تأیید شد.")
        elif action == "reject":
            feedback = request.POST.get("feedback")
            if feedback:
                if is_committee:
                    if participation.status == "supervisor_review":
                        participation.status = "manager_review"
                        participation.supervisor_status = "rejected"
                        participation.supervisor_feedback = feedback
                        participation.save()
                        messages.success(request, "مشارکت رد شد.")
                    elif participation.status == "factory_manager_review":
                        participation.status = "rejected"
                        participation.feedback = feedback
                        participation.save()
                        messages.success(request, "مشارکت رد شد.")

                    elif participation.status == "manager_review":

                        # MARK: management committee todo

                        if real_role in left_manager_review:
                            if real_role == "department_manager":
                                participation.manager_status = "rejected"
                                participation.manager_feedback = feedback
                            elif real_role == "department_manager_2":
                                participation.manager_2_status = "rejected"
                                participation.manager_2_feedback = feedback
                            elif real_role == "department_manager_3":
                                participation.manager_3_status = "rejected"
                                participation.manager_3_feedback = feedback

                        participation.save()
                        messages.success(request, "مشارکت رد شد.")

                        left_manager_review = []
                        if not participation.manager_status:
                            left_manager_review.append("department_manager")
                        if not participation.manager_2_status:
                            left_manager_review.append("department_manager_2")
                        if not participation.manager_3_status:
                            left_manager_review.append("department_manager_3")

                        if not left_manager_review and is_committee:
                            participation.status = "factory_manager_review"
                            participation.save()
                        # MARK: management todo end

                else:
                    participation.status = "rejected"
                    participation.feedback = feedback
                    participation.save()
                    messages.success(request, "مشارکت رد شد.")
            else:
                messages.error(request, "لطفاً دلیل رد را وارد کنید.")
        elif action == "return_to_user":
            feedback = request.POST.get("feedback")
            if participation.return_count < 3:
                if feedback:
                    participation.status = "rejected"
                    participation.feedback = feedback
                    participation.return_count += 1
                    participation.save()
                    messages.success(request, "مشارکت رد شد.")

                else:
                    messages.error(request, "لطفاً دلیل رد را وارد کنید.")
                    participation.status = "user_review"
                    participation.is_finalized = False
                    participation.save(update_fields=["status", "is_finalized"])
                    messages.success(request, "مشارکت به کاربر برگردانده شد.")

            else:
                messages.error(
                    request,
                    "این مشارکت 3 مرتبه برگردانده شده است و دیگر نمیتوانید آنرا به کاربر برگردانید (فقط امکان رد یا تایید دارید)",
                )
                return redirect("users:review_participation", participation_id)

        return redirect("users:management_dashboard")

    # print(left_manager_review)
    # print(real_role)

    print(role_name)
    print(participation.status)

    has_review_access = False
    if is_committee:
        if role_name == "supervisor" and participation.status == "supervisor_review":
            has_review_access = True
        elif (
            # MARK: management committee todo
            role_name == "department_manager"
            and participation.status == "manager_review"
            and real_role in left_manager_review
        ):
            has_review_access = True
        # has_review_access = role_name in ["supervisor", "department_manager"] and participation.status in ["supervisor_review", "manager_review"] and real_role in left_manager_review
    else:
        has_review_access = role_name in [
            "supervisor",
            "department_manager",
        ] and participation.status in ["supervisor_review", "manager_review"]

    left_manager_review = []
    if not participation.manager_status:
        left_manager_review.append("department_manager")
    if not participation.manager_2_status:
        left_manager_review.append("department_manager_2")
    if not participation.manager_3_status:
        left_manager_review.append("department_manager_3")

    if not left_manager_review and is_committee:
        participation.status = "factory_manager_review"
        participation.save()

    # MARK: management todo end

    if not has_review_access:
        has_review_access = (
            role_name in ["factory_manager"]
            and participation.status in ["factory_manager_review"]
            and participation.is_committee
        )

    return render(
        request,
        "users/review_participation.html",
        {
            "participation": participation,
            "has_review_access": has_review_access,
            "role_name": role_name,
        },
    )


@login_required
def chat_page(request):
    """رندر کردن صفحه اصلی چت‌بات."""
    # اگر تاریخچه چت در سشن نیست، آن را مقداردهی اولیه می‌کنیم
    if "chat_history" not in request.session:
        # history را به صورت لیستی از dict‌ها ذخیره می‌کنیم تا قابلیت سریالایز شدن در سشن را داشته باشد
        # هر آیتم به شکل {'content': 'text', 'source': 'User'/'Assistant'}
        request.session["chat_history"] = []

    return render(
        request, "users/chat.html", {"chat_history": request.session["chat_history"]}
    )


@login_required
def send_message(request):
    """مدیریت درخواست‌های AJAX برای ارسال پیام به چت‌بات."""
    if request.method == "POST":
        user_query = request.POST.get("message")

        if not user_query:
            return JsonResponse({"error": "پیام خالی ارسال شده است."}, status=400)

        # بازیابی تاریخچه چت از سشن
        # تاریخچه را از فرمت dict به آبجکت‌های TextMessage تبدیل می‌کنیم
        history_dicts = request.session.get("chat_history", [])

        # ما نیاز به تبدیل دیکشنری‌های ذخیره شده به آبجکت‌های TextMessage داریم
        # تا با chat_with_bot سازگار باشند.

        history_objects = [
            TextMessage(content=item["content"], source=item["source"])
            for item in history_dicts
        ]

        # اجرای تابع چت‌بات و دریافت پاسخ
        # تابع chat_with_bot، history_objects را به صورت 'pass by reference' به روز می‌کند
        try:
            agent_response = chat_with_bot(user_query, history_objects)
        except Exception as e:
            return JsonResponse({"error": f"خطا در اجرای چت‌بات: {e}"}, status=500)

        history_dicts.append({"content": user_query, "source": "User"})
        # 2. پاسخ ایجنت
        history_dicts.append({"content": agent_response, "source": "Assistant"})

        request.session["chat_history"] = history_dicts
        request.session.modified = True  # اطمینان از ذخیره شدن سشن

        return JsonResponse(
            {"user_message": user_query, "assistant_response": agent_response}
        )

    return JsonResponse({"error": "متد نامعتبر"}, status=405)


@login_required
def change_password_view(request):
    if request.method == "POST":
        # از فرم استاندارد جنگو برای مدیریت اعتبار سنجی رمز عبور استفاده می‌کنیم
        form = CustomPasswordChangeForm(user=request.user, data=request.POST)

        was_first_login = request.user.is_first_login

        if "old_password" in form.errors:
            # 1. تشخیص خطای رمز عبور قدیمی
            if "Your old password was entered incorrectly" in str(
                form.errors["old_password"]
            ):
                # 2. پاک کردن خطای انگلیسی موجود
                del form.errors["old_password"]

                # 3. تزریق خطای فارسی به فرم
                form.add_error(
                    "old_password",
                    "رمز عبور فعلی به درستی وارد نشده است. لطفاً دوباره تلاش کنید.",
                )

        if form.is_valid():
            user = form.save()  # رمز عبور جدید را ذخیره می‌کند و هش می‌کند
            update_session_auth_hash(request, user)

            if was_first_login:

                user.is_first_login = False  # تنظیم به 1

                user.save(update_fields=["is_first_login"])

            messages.success(request, "رمز عبور شما با موفقیت تغییر کرد.")
            # return redirect("users:dashboard")
            return redirect("users:landing")

        else:
            return render(request, "users/change_password.html", {"form": form})
    else:
        # متد GET: نمایش فرم خالی
        form = CustomPasswordChangeForm(user=request.user)

    return render(request, "users/change_password.html", {"form": form})


@login_required
def import_employees_view(request):

    if not request.user.is_staff:
        # توجه: باید نام صحیح داشبورد را جایگزین کنید (مثلاً 'users:dashboard')
        messages.error(request, "شما مجاز به دسترسی به این بخش نیستید.")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    if request.method == "POST":
        form = EmployeeImportForm(request.POST, request.FILES)
        if form.is_valid():
            excel_file = form.cleaned_data["excel_file"]

            # ✅ فراخوانی ماژول سرویس برای پردازش داده
            results = import_employees_from_excel(excel_file)

            # مدیریت پیام‌ها بر اساس نتایج
            if results["errors"]:
                messages.warning(
                    request,
                    f"عملیات با اخطار به پایان رسید. تعداد {results['success']} کارمند وارد/به‌روزرسانی شدند.",
                )
                for error in results["errors"]:
                    messages.error(request, error)
            else:
                messages.success(
                    request,
                    f"عملیات با موفقیت انجام شد. {results['success']} کارمند با موفقیت وارد/به‌روزرسانی شدند.",
                )

            return redirect("users:import_employees")  # بازگشت به صفحه خود فرم

    else:
        form = EmployeeImportForm()

    return render(request, "users/import_employees.html", {"form": form})


@login_required
def family_management(request):

    if request.method == "POST" and request.POST.get("action") == "delete":
        dependent_id = request.POST.get("dependent_id")
        Dependent.objects.filter(id=dependent_id, employee=request.user).delete()
        return redirect("users:family_management")

    dependents = request.user.dependents.all()
    context = {"dependents": dependents}
    return render(request, "users/family_management.html", context)


@login_required
def add_dependent(request):

    edit_id = request.POST.get("edit_id") or request.GET.get("edit")
    dependent = None
    if edit_id:
        try:
            dependent = Dependent.objects.get(id=edit_id, employee=request.user)
            print(dependent)
        except Dependent.DoesNotExist:
            messages.error(request, "عضو موردنظر یافت نشد یا دسترسی ندارید.")
            return redirect("users:family_management")

    if request.method == "POST":
        print(dependent)
        try:
            # دریافت داده‌ها از فرم
            first_name = request.POST.get("first_name")
            last_name = request.POST.get("last_name")
            father_name = request.POST.get("father_name")
            birth_date = request.POST.get("birth_date")  # فرمت شمسی: YYYY/MM/DD
            gender_code = request.POST.get("gender_code")
            marital_status_code = request.POST.get("marital_status_code")
            national_id = request.POST.get("national_id")
            birth_certificate_number = request.POST.get("birth_certificate_number")
            phone_number = request.POST.get("phone_number")  # برای ContactInfo
            relative_type_code = request.POST.get("relative_type_code")
            dependency_status_code = request.POST.get("dependency_status_code")
            bank_code = request.POST.get("bank_code")

            # اعتبارسنجی ساده (می‌تونی پیشرفته‌تر کنی)
            if not all(
                [
                    first_name,
                    last_name,
                    father_name,
                    birth_date,
                    national_id,
                    gender_code,
                    relative_type_code,
                ]
            ):
                messages.error(request, "لطفاً تمام فیلدهای اجباری را پر کنید.")
                return redirect("users:add_dependent")

            # تبدیل تاریخ شمسی به میلادی (با jdatetime)
            try:
                j_date = jdatetime.datetime.strptime(birth_date, "%Y/%m/%d")
                gregorian_birth_date = j_date.togregorian().date()
            except:
                messages.error(request, "فرمت تاریخ تولد نامعتبر است.")
                return redirect("users:add_dependent")

            # دریافت اشیاء مرتبط
            gender = Gender.objects.get(code=gender_code)
            relative_type = RelativeType.objects.get(code=relative_type_code)
            country = Country.objects.get(
                code=999
            )  # ایران، کد 13 رو فرض کردم — تغییر بده اگر لازم بود

            marital_status = None
            if marital_status_code:
                marital_status = MaritalStatus.objects.get(code=marital_status_code)

            dependency_status = None
            if dependency_status_code:
                dependency_status = DependencyStatus.objects.get(
                    code=dependency_status_code
                )

            if dependent:  # یعنی حالت ویرایش
                # به‌روزرسانی فیلدهای موجود
                dependent.first_name = first_name
                dependent.last_name = last_name
                dependent.father_name = father_name
                dependent.national_id = national_id
                dependent.birth_certificate_number = birth_certificate_number or ""
                dependent.birth_date = gregorian_birth_date
                dependent.gender = gender
                dependent.relative_type = relative_type
                dependent.marital_status = marital_status
                dependent.dependency_status = dependency_status
                dependent.country = country
                dependent.save()

                success_message = (
                    f'اطلاعات "{first_name} {last_name}" با موفقیت به‌روزرسانی شد.'
                )
            else:  # حالت افزودن جدید
                dependent = Dependent.objects.create(
                    employee=request.user,
                    relative_type=relative_type,
                    national_id=national_id,
                    first_name=first_name,
                    last_name=last_name,
                    father_name=father_name,
                    birth_certificate_number=birth_certificate_number or "",
                    birth_date=gregorian_birth_date,
                    marital_status=marital_status,
                    dependency_status=dependency_status,
                    gender=gender,
                    country=country,
                )
                success_message = (
                    f'عضو خانواده "{first_name} {last_name}" با موفقیت ثبت شد.'
                )

            # افزودن شماره تماس (اگر موبایل یا تلفن وارد شده)
            if phone_number:
                contact_number = phone_number  # اولویت با موبایل
                if len(contact_number) == 11 and contact_number.startswith("09"):
                    ContactInfo.objects.update_or_create(
                        dependent=dependent, defaults={"phone_number": phone_number}
                    )
            else:
                ContactInfo.objects.filter(dependent=dependent).delete()

            if bank_code:
                try:
                    bank = Banks.objects.get(code=bank_code)
                    account_type_code = request.POST.get("bank_account_type_code")
                    account_number = request.POST.get("account_number", "").strip()
                    sheba_number = request.POST.get("sheba_number", "").strip()
                    card_number = request.POST.get("card_number", "").strip()

                    if account_type_code and (
                        account_number or sheba_number or card_number
                    ):
                        account_type = BankAccountType.objects.get(
                            code=account_type_code
                        )
                        BankAccount.objects.update_or_create(
                            dependent=dependent,
                            defaults={
                                "bank": bank,
                                "bank_account_type": account_type,
                                "account_number": account_number,
                                "sheba_number": sheba_number,
                                "card_number": card_number,
                            },
                        )
                except Exception as bank_error:
                    messages.warning(
                        request,
                        f"عضو ثبت شد، اما خطا در ثبت حساب بانکی: {str(bank_error)}",
                    )
            else:
                BankAccount.objects.filter(dependent=dependent).delete()

            messages.success(request, success_message)
            return redirect("users:family_management")

        except Exception as e:
            messages.error(request, f"خطا در عملیات: {str(e)}")
            return redirect(request.path + (f"?edit={edit_id}" if edit_id else ""))

    # GET request - نمایش فرم
    initial_data = {}
    if dependent:
        # پر کردن initial_data برای حالت ویرایش
        j_birth_date = jdatetime.date.fromgregorian(date=dependent.birth_date)
        initial_data = {
            "first_name": dependent.first_name,
            "last_name": dependent.last_name,
            "father_name": dependent.father_name,
            "national_id": dependent.national_id,
            "birth_certificate_number": dependent.birth_certificate_number,
            "birth_date": j_birth_date.strftime("%Y/%m/%d"),  # تبدیل به شمسی
            "gender_code": dependent.gender.code if dependent.gender else "",
            "marital_status_code": (
                dependent.marital_status.code if dependent.marital_status else ""
            ),
            "relative_type_code": dependent.relative_type.code,
            "dependency_status_code": (
                dependent.dependency_status.code if dependent.dependency_status else ""
            ),
        }

        # شماره تماس
        try:
            contact = dependent.contact_infos.first()
            if contact:
                initial_data["phone_number"] = contact.phone_number
        except:
            pass

        # حساب بانکی
        try:
            bank_account = dependent.bankaccount_set.first()
            if bank_account:
                initial_data.update(
                    {
                        "bank_code": bank_account.bank.code,
                        "bank_account_type_code": bank_account.bank_account_type.code,
                        "account_number": bank_account.account_number,
                        "sheba_number": bank_account.sheba_number,
                        "card_number": bank_account.card_number,
                    }
                )
        except:
            pass

    context = {
        "genders": Gender.objects.all().order_by("code"),
        "marital_statuses": MaritalStatus.objects.all().order_by("code"),
        "relative_types": RelativeType.objects.all().order_by("code"),
        "dependency_statuses": DependencyStatus.objects.all().order_by("code"),
        "banks": Banks.objects.all().order_by("name"),
        "bank_account_types": BankAccountType.objects.all().order_by("code"),
        "is_edit": bool(edit_id),  # برای نمایش عنوان مناسب در تمپلیت
        "edit_id": edit_id,
        **initial_data,  # این مقادیر به عنوان value در inputها استفاده می‌شوند
    }
    return render(request, "users/add_dependent.html", context)


@login_required
def manage_bimeh(request):

    role_name = request.session["current_role"]
    holding_id = request.session["current_holding_id"]
    factory_id = request.session["current_factory_id"]
    department_id = request.session["current_department_id"]
    subdepartment_id = request.session["current_subdepartment_id"]
    management_tree = request.session.get("management_tree", [])
    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]
    is_committee = request.session["current_is_committee"]
    real_role = request.session["current_real_role"]

    user = request.user

    has_management_access = role_name in management_roles

    factory_bimeh = user.factory_bimeh
    holding_bimeh = user.holding_bimeh

    if holding_id:
        factory_list = Factory.objects.filter(holding__id=holding_id)
    else:
        factory_list = Factory.objects.filter()

    can_manage_bimeh = factory_bimeh or holding_bimeh
    can_export_bimeh_excel = factory_bimeh or holding_bimeh
    can_import_bimeh_excel = holding_bimeh

    # print(Factory.objects.filter(id=factory_id))

    if not can_manage_bimeh:
        messages.error(request, "شما اجازه دسترسی به این صفحه را ندارید..")
        # return redirect("users:dashboard")
        return redirect("users:landing")

    if (
        request.GET.get("export") == "full"
        or request.GET.get("export") == "with_family_full"
    ):

        employees = (
            Employee.objects.filter(is_active=True)
            .select_related("gender", "marital_status", "dependency_status")
            .prefetch_related(
                "dependents__gender",
                "dependents__marital_status",
                "dependents__dependency_status",
                "dependents__relative_type",
                "dependents__country",
                "bimeh",
                "bimeh__employment_type",
                "bimeh__job_group",
                "bimeh__base_insurance",
                "bimeh__country",
                "bank_accounts__bank",
                "bank_accounts__bank_account_type",
                "contact_infos",
            )
        )

        # لیست برای جمع‌آوری همه ردیف‌ها (پرسنل + وابستگان)
        data_rows = []

        for emp in employees:

            selected_factory_id = request.GET.get("factory")
            user_factory = ""
            related_factories = Factory.objects.filter()

            if factory_bimeh:

                # MARK: management todo
                related_factories = related_factories.filter(id=factory_id).filter(
                    Q(manager=emp)
                    | Q(departments__manager=emp)
                    | Q(departments__managers=emp)
                    | Q(departments__manager_2=emp)
                    | Q(departments__manager_3=emp)
                    | Q(departments__subdepartments__supervisor=emp)
                    | Q(departments__subdepartments__supervisors=emp)
                    | Q(departments__subdepartments__assigned_employees=emp)
                )
            if holding_bimeh and selected_factory_id:
                related_factories = related_factories.filter(
                    id=selected_factory_id
                ).filter(
                    Q(manager=emp)
                    | Q(departments__manager=emp)
                    | Q(departments__managers=emp)
                    | Q(departments__manager_2=emp)
                    | Q(departments__manager_3=emp)
                    | Q(departments__subdepartments__supervisor=emp)
                    | Q(departments__subdepartments__supervisors=emp)
                    | Q(departments__subdepartments__assigned_employees=emp)
                )

            # MARK: management todo end

            if not related_factories:
                continue

            if request.GET.get("export") == "with_family_full":
                depen = emp.dependents.all()

                if not depen.exists():
                    continue

            # --- اطلاعات مشترک ---
            bimeh = (
                emp.bimeh.first()
            )  # فرض: هر کارمند حداکثر یک رکورد Employee_Bimeh دارد
            main_personnel_code = emp.personnel_code or ""
            main_national_id = emp.national_id

            # شماره موبایل (اولویت: ContactInfo با موبایل، در غیر این صورت phone_number اصلی)
            mobile = ""
            contact = emp.contact_infos.first()
            if contact:
                mobile = contact.phone_number
            elif emp.phone_number:
                mobile = emp.phone_number

            # حساب بانکی اصلی کارمند
            bank_account = emp.bank_accounts.first()
            bank_code = (
                bank_account.bank.code if bank_account and bank_account.bank else ""
            )
            account_number = bank_account.account_number if bank_account else ""
            sheba = bank_account.sheba_number if bank_account else ""
            account_type_code = (
                bank_account.bank_account_type.code
                if bank_account and bank_account.bank_account_type
                else ""
            )
            owner_name = f"{emp.first_name} {emp.last_name}"

            # واحد سازمانی (مثال: کارخانه - بخش)
            organizational_unit = ""
            if emp.assigned_subdepartments.exists():
                subdept = emp.assigned_subdepartments.first()
                organizational_unit = (
                    f"{subdept.department.factory.name} - {subdept.department.name}"
                )
            elif hasattr(emp, "department"):
                organizational_unit = emp.department.name if emp.department else ""

            # --- اضافه کردن خود کارمند (بیمه‌شده اصلی) ---
            # factory_ids, management_tree_1, is_holding_manager, managing_holdings_ids = get_factory_ids()
            factory_name = related_factories.first().name
            # print(factory_name)

            data_rows.append(
                {
                    "ردیف بیمه شده": "",  # خالی می‌ماند یا می‌تونی شماره‌گذاری کنی
                    "کد پرسنلی بیمه شده اصلی": main_personnel_code,
                    "نام": emp.first_name or "",
                    "نام خانوادگی": emp.last_name or "",
                    "نام پدر": emp.father_name or "",
                    "تاریخ تولد": (
                        jdatetime.date.fromgregorian(date=emp.birth_date).strftime(
                            "%Y/%m/%d"
                        )
                        if emp.birth_date
                        else ""
                    ),
                    "کد جنسیت": emp.gender.code if emp.gender else "",
                    "کد وضعیت تأهل": (
                        emp.marital_status.code if emp.marital_status else ""
                    ),
                    "کد ملی": emp.national_id,
                    "شماره شناسنامه": emp.birth_certificate_number or "",
                    "شماره تلفن": emp.phone_number or "",
                    "موبایل": mobile if mobile else "",
                    "کد نسبت با بیمه شده اصلی": 1,  # 1 = بیمه‌شده اصلی
                    "کد وضعیت تکفل": 3,  # 3 = بیمه‌شده اصلی (طبق لیست کدها)
                    "کد گروه": (
                        bimeh.job_group.code if bimeh and bimeh.job_group else ""
                    ),
                    "تاریخ استخدام": (
                        jdatetime.date.fromgregorian(
                            date=bimeh.employment_date
                        ).strftime("%Y/%m/%d")
                        if bimeh and bimeh.employment_date
                        else ""
                    ),
                    "کد نوع بیمه پایه": (
                        bimeh.base_insurance.code
                        if bimeh and bimeh.base_insurance
                        else ""
                    ),
                    "کد بانک": bank_code,
                    "شماره حساب": account_number,
                    "IR": "IR",
                    "شماره شبا": sheba,
                    "نوع حساب": account_type_code,
                    "صاحب حساب": owner_name,
                    "کد پرسنلی بیمه شده اصلی": main_personnel_code,
                    "کد ملی بیمه شده اصلی": main_national_id,
                    "علت درخواست": "",  # todo
                    "نوع استخدام": (
                        bimeh.employment_type.code
                        if bimeh and bimeh.employment_type
                        else ""
                    ),
                    "کد بیمه گر قبلی": (
                        bimeh.previous_insurer_id
                        if bimeh and bimeh.previous_insurer_id
                        else ""
                        # ""
                    ),
                    "مدت پوشش(ماه)": (
                        bimeh.coverage_duration
                        if bimeh and bimeh.coverage_duration
                        else ""
                        # ""
                    ),
                    "کد واحد سازمانی": organizational_unit,
                    "کد کشور(فقط برای اتباع خارجی)": (
                        bimeh.country.code if bimeh and bimeh.country else ""
                    ),
                    "نام کارخانه کارمند اصلی": factory_name,
                }
            )

            # --- اضافه کردن وابستگان ---
            for dep in emp.dependents.all():
                # موبایل وابسته
                dep_mobile = ""
                dep_contact = dep.contact_infos.filter(
                    phone_number__startswith="09"
                ).first()
                if dep_contact:
                    dep_mobile = dep_contact.phone_number

                # حساب بانکی وابسته
                dep_bank_account = dep.bank_accounts.first()
                dep_bank_code = (
                    dep_bank_account.bank.code
                    if dep_bank_account and dep_bank_account.bank
                    else ""
                )
                dep_account_number = (
                    dep_bank_account.account_number if dep_bank_account else ""
                )

                if dep.relative_type.code and str(dep.relative_type.code) in [
                    "1",
                    "2",
                    "3",
                    "4",
                    "7",
                    "8",
                ]:
                    dep_sheba = sheba
                else:
                    dep_sheba = (
                        dep_bank_account.sheba_number if dep_bank_account else ""
                    )

                dep_account_type_code = (
                    dep_bank_account.bank_account_type.code
                    if dep_bank_account and dep_bank_account.bank_account_type
                    else ""
                )
                dep_owner_name = f"{dep.first_name} {dep.last_name}"

                data_rows.append(
                    {
                        "ردیف بیمه شده": "",
                        "کد پرسنلی بیمه شده اصلی": main_personnel_code,
                        "نام": dep.first_name,
                        "نام خانوادگی": dep.last_name,
                        "نام پدر": dep.father_name or "",
                        "تاریخ تولد": (
                            jdatetime.date.fromgregorian(date=dep.birth_date).strftime(
                                "%Y/%m/%d"
                            )
                            if dep.birth_date
                            else ""
                        ),
                        "کد جنسیت": dep.gender.code if dep.gender else "",
                        "کد وضعیت تأهل": (
                            dep.marital_status.code if dep.marital_status else ""
                        ),
                        "کد ملی": dep.national_id,
                        "شماره شناسنامه": dep.birth_certificate_number or "",
                        "شماره تلفن": "",  # معمولاً وابسته تلفن ثابت نداره
                        "موبایل": dep_mobile,
                        "کد نسبت با بیمه شده اصلی": (
                            dep.relative_type.code if dep.relative_type else ""
                        ),
                        "کد وضعیت تکفل": (
                            dep.dependency_status.code if dep.dependency_status else ""
                        ),
                        "کد گروه": (
                            bimeh.job_group.code if bimeh and bimeh.job_group else ""
                        ),
                        "تاریخ استخدام": "",  # وابسته استخدام نداره
                        "کد نوع بیمه پایه": (
                            bimeh.base_insurance.code
                            if bimeh and bimeh.base_insurance
                            else ""
                        ),
                        "کد بانک": dep_bank_code,
                        "شماره حساب": dep_account_number,
                        "IR": "IR",
                        "شماره شبا": dep_sheba,
                        "نوع حساب": dep_account_type_code,
                        "صاحب حساب": dep_owner_name,
                        "کد پرسنلی بیمه شده اصلی": main_personnel_code,
                        "کد ملی بیمه شده اصلی": main_national_id,
                        "علت درخواست": "",
                        "نوع استخدام": "",
                        "کد بیمه گر قبلی": "",
                        "مدت پوشش(ماه)": "",
                        "کد واحد سازمانی": organizational_unit,
                        "کد کشور(فقط برای اتباع خارجی)": (
                            dep.country.code if dep.country else ""
                        ),
                        "نام کارخانه کارمند اصلی": factory_name,
                    }
                )

        # ساخت ستون‌ها برای تابع export_to_excel
        columns = [
            ("ردیف بیمه شده", [row["ردیف بیمه شده"] for row in data_rows]),
            (
                "کد پرسنلی بیمه شده اصلی",
                [row["کد پرسنلی بیمه شده اصلی"] for row in data_rows],
            ),
            ("نام", [row["نام"] for row in data_rows]),
            ("نام خانوادگی", [row["نام خانوادگی"] for row in data_rows]),
            ("نام پدر", [row["نام پدر"] for row in data_rows]),
            ("تاریخ تولد", [row["تاریخ تولد"] for row in data_rows]),
            ("کد جنسیت", [row["کد جنسیت"] for row in data_rows]),
            ("کد وضعیت تأهل", [row["کد وضعیت تأهل"] for row in data_rows]),
            ("کد ملی", [row["کد ملی"] for row in data_rows]),
            ("شماره شناسنامه", [row["شماره شناسنامه"] for row in data_rows]),
            ("شماره تلفن", [row["شماره تلفن"] for row in data_rows]),
            ("موبایل", [row["موبایل"] for row in data_rows]),
            (
                "کد نسبت با بیمه شده اصلی",
                [row["کد نسبت با بیمه شده اصلی"] for row in data_rows],
            ),
            ("کد وضعیت تکفل", [row["کد وضعیت تکفل"] for row in data_rows]),
            ("کد گروه", [row["کد گروه"] for row in data_rows]),
            ("تاریخ استخدام", [row["تاریخ استخدام"] for row in data_rows]),
            ("کد نوع بیمه پایه", [row["کد نوع بیمه پایه"] for row in data_rows]),
            ("کد بانک", [row["کد بانک"] for row in data_rows]),
            ("شماره حساب", [row["شماره حساب"] for row in data_rows]),
            ("IR", [row["IR"] for row in data_rows]),
            ("شماره شبا", [row["شماره شبا"] for row in data_rows]),
            ("نوع حساب", [row["نوع حساب"] for row in data_rows]),
            ("صاحب حساب", [row["صاحب حساب"] for row in data_rows]),
            (
                "کد پرسنلی بیمه شده اصلی",
                [row["کد پرسنلی بیمه شده اصلی"] for row in data_rows],
            ),
            (
                "کد ملی بیمه شده اصلی",
                [row["کد ملی بیمه شده اصلی"] for row in data_rows],
            ),
            ("علت درخواست", [row["علت درخواست"] for row in data_rows]),
            ("نوع استخدام", [row["نوع استخدام"] for row in data_rows]),
            ("کد بیمه گر قبلی", [row["کد بیمه گر قبلی"] for row in data_rows]),
            ("مدت پوشش(ماه)", [row["مدت پوشش(ماه)"] for row in data_rows]),
            ("کد واحد سازمانی", [row["کد واحد سازمانی"] for row in data_rows]),
            (
                "کد کشور(فقط برای اتباع خارجی)",
                [row["کد کشور(فقط برای اتباع خارجی)"] for row in data_rows],
            ),
            (
                "نام کارخانه کارمند اصلی",
                [row["نام کارخانه کارمند اصلی"] for row in data_rows],
            ),
        ]

        # عنوان گزارش و نام فایل
        today_jalali = jdatetime.date.today().strftime("%Y/%m/%d")
        filename = f"Bimeh_Takmili_{today_jalali.replace('/', '-')}"
        report_title = f"لیست بیمه‌شدگان تکمیلی - تولید شده در {today_jalali}"

        return export_to_excel(
            columns=columns, filename=filename, report_title=report_title
        )

    elif request.method == "POST" and "upload" in request.POST:
        excel_file = request.FILES.get("excel_file")
        print("AAA")
        if excel_file:
            try:
                result = import_from_excel(excel_file)
                messages.success(
                    request,
                    f"ایمپورت موفق: {result['employees']} کارمند و {result['dependents']} وابسته ایجاد شد.",
                )
                if result["errors"]:
                    messages.warning(
                        request, "برخی خطاها رخ داد: " + "; ".join(result["errors"])
                    )
            except Exception as e:
                messages.error(request, f"خطا در ایمپورت فایل: {str(e)}")
        else:
            messages.error(request, "هیچ فایلی انتخاب نشده است.")

    context = {
        "factory_bimeh": factory_bimeh,
        "holding_bimeh": holding_bimeh,
        "can_manage_bimeh": can_manage_bimeh,
        "can_export_bimeh_excel": can_export_bimeh_excel,
        "can_import_bimeh_excel": can_import_bimeh_excel,
        "factory_list": factory_list,
    }

    return render(request, "users/manage_bimeh.html", context)


@login_required
def insurance_info(request):
    employee = request.user  # فرض: user به Employee لینک شده

    # گرفتن اطلاعات موجود (اگر باشه)
    bimeh = employee.bimeh.first()  # معمولاً یکی هست
    bank_account = employee.bank_accounts.first()
    phone_number = employee.contact_infos.first()

    # تبدیل تاریخ میلادی به جلالی برای نمایش
    birth_date_jalali = ""
    employment_date_jalali = ""
    if employee.birth_date:
        birth_date_jalali = jdatetime.date.fromgregorian(
            date=employee.birth_date
        ).strftime("%Y/%m/%d")
    if bimeh and bimeh.employment_date:
        employment_date_jalali = jdatetime.date.fromgregorian(
            date=bimeh.employment_date
        ).strftime("%Y/%m/%d")

    context = {
        # لیست‌های کد برای سلکت‌ها
        "genders": Gender.objects.all(),
        "marital_statuses": MaritalStatus.objects.all(),
        "job_groups": JobGroup.objects.all(),
        "base_insurances": BaseInsurance.objects.all(),
        "employment_types": EmploymentType.objects.all(),
        "previous_insurers": PreviousInsurer.objects.all(),
        "banks": Banks.objects.all(),
        "bank_account_types": BankAccountType.objects.all(),
        "countries": Country.objects.all(),
        # اطلاعات فعلی برای پر کردن فرم
        "current": {
            "personnel_code": employee.personnel_code or "",
            "first_name": employee.first_name or "",
            "last_name": employee.last_name or "",
            "national_id": employee.national_id or "",
            "father_name": employee.father_name or "",
            "birth_date_jalali": birth_date_jalali,
            "gender_code": employee.gender.code if employee.gender else "",
            "marital_status_code": (
                employee.marital_status.code if employee.marital_status else ""
            ),
            "birth_certificate_number": employee.birth_certificate_number or "",
            "job_group_code": bimeh.job_group.code if bimeh and bimeh.job_group else "",
            "employment_date_jalali": employment_date_jalali,
            "base_insurance_code": (
                bimeh.base_insurance.code if bimeh and bimeh.base_insurance else ""
            ),
            "employment_type_code": (
                bimeh.employment_type.code if bimeh and bimeh.employment_type else ""
            ),
            "previous_insurer_code": (
                bimeh.previous_insurer.code if bimeh and bimeh.previous_insurer else ""
            ),
            "coverage_duration": bimeh.coverage_duration if bimeh else "",
            "bank_code": (
                bank_account.bank.code if bank_account and bank_account.bank else ""
            ),
            "bank_account_type_code": (
                bank_account.bank_account_type.code
                if bank_account and bank_account.bank_account_type
                else ""
            ),
            "account_number": (
                (bank_account.account_number or "") if bank_account else ""
            ),
            "card_number": (bank_account.card_number or "") if bank_account else "",
            "sheba_number": (
                bank_account.sheba_number  # .replace("IR", "")
                if bank_account and bank_account.sheba_number
                else ""
            ),
            "country_code": bimeh.country.code if bimeh and bimeh.country else "",
            "phone_number": (
                phone_number.phone_number
                if phone_number and phone_number.phone_number
                else ""
            ),
        },
    }

    if request.method == "POST":
        # ذخیره اطلاعات شخصی در Employee
        employee.father_name = request.POST.get("father_name", employee.father_name)
        employee.birth_certificate_number = request.POST.get(
            "birth_certificate_number", employee.birth_certificate_number
        )
        gender_code = request.POST.get("gender_code")
        if gender_code:
            try:
                employee.gender = Gender.objects.get(code=gender_code)
            except Gender.DoesNotExist:
                pass  # یا error handling
        marital_status_code = request.POST.get("marital_status_code")
        if marital_status_code:
            try:
                employee.marital_status = MaritalStatus.objects.get(
                    code=marital_status_code
                )
            except MaritalStatus.DoesNotExist:
                pass
        birth_date_str = request.POST.get("birth_date")
        if birth_date_str:
            try:
                y, m, d = map(int, birth_date_str.split("/"))
                employee.birth_date = jdatetime.date(y, m, d).togregorian()
            except ValueError:
                pass  # error handling if needed

        phone_number = request.POST.get("phone_number", "").strip()

        if phone_number:
            # اعتبارسنجی ساده: باید با 09 شروع بشه و 11 رقمی باشه
            if len(phone_number) != 11 or not phone_number.isdigit():
                pass
            else:
                # اول همه شماره‌های موبایل قبلی این کارمند رو حذف کن
                ContactInfo.objects.filter(employee=employee).delete()

                # سپس شماره جدید رو بساز
                ContactInfo.objects.create(
                    employee=employee,
                    phone_number=phone_number,
                )
        else:
            # اگر کاربر شماره رو خالی گذاشت، همه شماره‌های موبایل رو حذف کن
            ContactInfo.objects.filter(employee=employee).delete()

        employee.save()

        # ذخیره اطلاعات بیمه در Employee_Bimeh
        if not bimeh:
            bimeh = Employee_Bimeh(employee=employee)
        job_group_code = request.POST.get("job_group_code")
        if job_group_code:
            try:
                bimeh.job_group = JobGroup.objects.get(code=job_group_code)
            except JobGroup.DoesNotExist:
                pass
        employment_date_str = request.POST.get("employment_date")
        if employment_date_str:
            try:
                y, m, d = map(int, employment_date_str.split("/"))
                bimeh.employment_date = jdatetime.date(y, m, d).togregorian()
            except ValueError:
                pass
        base_insurance_code = request.POST.get("base_insurance_code")
        if base_insurance_code:
            try:
                bimeh.base_insurance = BaseInsurance.objects.get(
                    code=base_insurance_code
                )
            except BaseInsurance.DoesNotExist:
                pass
        employment_type_code = request.POST.get("employment_type_code")
        if employment_type_code:
            try:
                bimeh.employment_type = EmploymentType.objects.get(
                    code=employment_type_code
                )
            except EmploymentType.DoesNotExist:
                pass
        previous_insurer_code = request.POST.get("previous_insurer_code")
        if previous_insurer_code:
            try:
                bimeh.previous_insurer = PreviousInsurer.objects.get(
                    code=previous_insurer_code
                )
            except PreviousInsurer.DoesNotExist:
                pass
        coverage_duration = request.POST.get("coverage_duration")
        if coverage_duration:
            try:
                bimeh.coverage_duration = int(coverage_duration)
            except ValueError:
                pass
        country_code = request.POST.get("country_code")
        if country_code:
            try:
                bimeh.country = Country.objects.get(code=country_code)
            except Country.DoesNotExist:
                pass
        bimeh.save()

        # ذخیره اطلاعات بانکی در BankAccount
        if not bank_account:
            bank_account = BankAccount(employee=employee)

        bank_code = request.POST.get("bank_code")
        if bank_code:
            try:
                bank_account.bank = Banks.objects.get(code=bank_code)
            except Banks.DoesNotExist:
                pass
        bank_account_type_code = request.POST.get("bank_account_type_code")

        if bank_account_type_code:
            try:
                bank_account.bank_account_type = BankAccountType.objects.get(
                    code=bank_account_type_code
                )
            except BankAccountType.DoesNotExist:
                pass
        bank_account.account_number = request.POST.get(
            "account_number", bank_account.account_number
        )
        bank_account.card_number = request.POST.get(
            "card_number", bank_account.card_number
        )
        sheba_number = request.POST.get("sheba_number")
        if sheba_number:
            bank_account.sheba_number = sheba_number.strip()
        bank_account.save()

        # ریدایرکت به داشبورد
        # return redirect("users:dashboard")
        return redirect("users:landing")  # تغییر دهید اگر نام url متفاوت است

    return render(request, "users/insurance_info.html", context)


# def import_from_excel(excel_file):
#     """
#     فانکشن برای ایمپورت داده‌ها از فایل اکسل به مدل‌های Django.
#     حالا excel_file یک file object هست (از request.FILES).
#     فرض: داده‌های پایه مثل Gender, MaritalStatus و غیره قبلاً در دیتابیس وجود دارند.
#     تاریخ‌ها شمسی هستند و با jdatetime تبدیل می‌شوند.
#     """
#     df = pd.read_excel(excel_file, sheet_name="لیست بیمه شدگان", header=0)
#     created_count = {"employees": 0, "dependents": 0, "errors": []}

#     with transaction.atomic():  # برای atomicity، اگر خطایی باشه rollback
#         for index, row in df.iterrows():
#             try:
#                 # تبدیل تاریخ تولد شمسی به میلادی
#                 birth_date_str = row.get("تاریخ تولد")
#                 if pd.notna(birth_date_str):
#                     try:
#                         jalali_date = jdatetime.date.fromstring(
#                             birth_date_str, "%Y/%m/%d"
#                         )
#                         birth_date = jalali_date.togregorian()
#                     except ValueError:
#                         raise ValueError(
#                             f"فرمت تاریخ تولد نامعتبر در ردیف {index}: {birth_date_str}"
#                         )
#                 else:
#                     birth_date = None

#                 # تبدیل تاریخ استخدام اگر وجود داشته باشه
#                 employment_date_str = row.get("تاریخ استخدام")
#                 if pd.notna(employment_date_str):
#                     try:
#                         jalali_emp_date = jdatetime.date.fromstring(
#                             employment_date_str, "%Y/%m/%d"
#                         )
#                         employment_date = jalali_emp_date.togregorian()
#                     except ValueError:
#                         employment_date = None
#                 else:
#                     employment_date = None

#                 # گرفتن ForeignKeyها بر اساس کد
#                 gender = (
#                     Gender.objects.get(code=row["کد جنسیت"])
#                     if pd.notna(row["کد جنسیت"])
#                     else None
#                 )
#                 marital_status = (
#                     MaritalStatus.objects.get(code=row["کد وضعیت تأهل"])
#                     if pd.notna(row["کد وضعیت تأهل"])
#                     else None
#                 )
#                 dependency_status = (
#                     DependencyStatus.objects.get(code=row["کد وضعیت تکفل"])
#                     if pd.notna(row["کد وضعیت تکفل"])
#                     else None
#                 )
#                 country = (
#                     Country.objects.get(code=row["کد کشور(فقط برای اتباع خارجی)"])
#                     if pd.notna(row["کد کشور(فقط برای اتباع خارجی)"])
#                     else Country.objects.get(code=1)
#                 )  # فرض کد ایران=1
#                 employment_type = (
#                     EmploymentType.objects.get(code=row["نوع استخدام "])
#                     if pd.notna(row["نوع استخدام "])
#                     else None
#                 )
#                 job_group = (
#                     JobGroup.objects.get(code=row["کد گروه"])
#                     if pd.notna(row["کد گروه"])
#                     else None
#                 )
#                 base_insurance = (
#                     BaseInsurance.objects.get(code=row["کد نوع بیمه پایه"])
#                     if pd.notna(row["کد نوع بیمه پایه"])
#                     else None
#                 )
#                 previous_insurer = (
#                     PreviousInsurer.objects.get(code=row["کد بیمه گر قبلی"])
#                     if pd.notna(row["کد بیمه گر قبلی"])
#                     else None
#                 )
#                 bank = (
#                     Banks.objects.get(code=row["کد بانک"])
#                     if pd.notna(row["کد بانک"])
#                     else None
#                 )
#                 bank_account_type = (
#                     BankAccountType.objects.get(code=row["نوع حساب"])
#                     if pd.notna(row["نوع حساب"])
#                     else None
#                 )

#                 national_id = (
#                     str(int(row["کد ملی"])) if pd.notna(row["کد ملی"]) else None
#                 )
#                 personnel_code = (
#                     str(int(row["کد پرسنلی بیمه شده اصلی"]))
#                     if pd.notna(row["کد پرسنلی بیمه شده اصلی"])
#                     else None
#                 )

#                 if row["کد نسبت با بیمه شده اصلی"] == 1:  # بیمه‌شده اصلی (Employee)
#                     # چک وجود قبلی
#                     if Employee.objects.filter(national_id=national_id).exists():
#                         continue  # یا update اگر بخواید

#                     employee = Employee.objects.create(
#                         national_id=national_id,
#                         first_name=row["نام"],
#                         last_name=row["نام خانوادگی"],
#                         father_name=row["نام پدر"],
#                         birth_date=birth_date,
#                         gender=gender,
#                         marital_status=marital_status,
#                         birth_certificate_number=(
#                             str(int(row["شماره شناسنامه"]))
#                             if pd.notna(row["شماره شناسنامه"])
#                             else None
#                         ),
#                         phone_number=(
#                             str(int(row["موبایل"])) if pd.notna(row["موبایل"]) else None
#                         ),
#                         personnel_code=personnel_code,
#                         # address اگر باشه، در اکسل نیست
#                         # roles: فرض پیش‌فرض employee
#                         # employee.roles.add(Role.objects.get(name='employee'))  # uncomment اگر نیاز
#                     )
#                     created_count["employees"] += 1

#                     # ایجاد Employee_Bimeh
#                     if any(
#                         [
#                             employment_date,
#                             employment_type,
#                             job_group,
#                             base_insurance,
#                             previous_insurer,
#                         ]
#                     ):
#                         Employee_Bimeh.objects.create(
#                             employee=employee,
#                             employment_date=employment_date,
#                             employment_type=employment_type,
#                             job_group=job_group,
#                             base_insurance=base_insurance,
#                             country=country,
#                             previous_insurer=previous_insurer,
#                             coverage_duration=(
#                                 int(row["مدت پوشش(ماه)"])
#                                 if pd.notna(row["مدت پوشش(ماه)"])
#                                 else None
#                             ),
#                         )

#                     # واحد سازمانی: parse و assign اگر نیاز باشه، مثلاً
#                     org_unit = row.get("کد واحد سازمانی")
#                     if org_unit:
#                         # فرض: 'اصفهان مقدم- تولید' → factory='اصفهان مقدم', department='تولید'
#                         parts = org_unit.split("-")
#                         if len(parts) == 2:
#                             factory_name = parts[0].strip()
#                             dept_name = parts[1].strip()
#                             factory, _ = Factory.objects.get_or_create(
#                                 name=factory_name
#                             )
#                             dept, _ = Department.objects.get_or_create(
#                                 name=dept_name, factory=factory
#                             )
#                             # assign به employee، اما در مدل Employee مستقیم نیست، شاید از طریق managed_ یا assigned_
#                             # مثلاً employee.managed_departments.add(dept) اگر مدیر باشه، иначе customize کنید

#                 else:  # وابسته (Dependent)
#                     # پیدا کردن Employee اصلی
#                     main_personnel_code = (
#                         str(int(row["کد پرسنلی بیمه شده اصلی"]))
#                         if pd.notna(row["کد پرسنلی بیمه شده اصلی"])
#                         else None
#                     )
#                     main_national_id = (
#                         str(int(row["کد ملی بیمه شده اصلی"]))
#                         if pd.notna(row["کد ملی بیمه شده اصلی"])
#                         else None
#                     )
#                     if main_personnel_code:
#                         main_employee = Employee.objects.get(
#                             personnel_code=main_personnel_code
#                         )
#                     elif main_national_id:
#                         main_employee = Employee.objects.get(
#                             national_id=main_national_id
#                         )
#                     else:
#                         raise ValueError(f"Employee اصلی پیدا نشد در ردیف {index}")

#                     relative_type = RelativeType.objects.get(
#                         code=row["کد نسبت با بیمه شده اصلی"]
#                     )

#                     dependent = Dependent.objects.create(
#                         employee=main_employee,
#                         relative_type=relative_type,
#                         national_id=national_id,
#                         first_name=row["نام"],
#                         last_name=row["نام خانوادگی"],
#                         father_name=row["نام پدر"],
#                         birth_certificate_number=(
#                             str(int(row["شماره شناسنامه"]))
#                             if pd.notna(row["شماره شناسنامه"])
#                             else None
#                         ),
#                         birth_date=birth_date,
#                         marital_status=marital_status,
#                         dependency_status=dependency_status,
#                         gender=gender,
#                         country=country,
#                     )
#                     created_count["dependents"] += 1

#                 # ایجاد BankAccount (برای employee یا dependent)
#                 if pd.notna(row["شماره شبا"]) or pd.notna(row["شماره حساب"]):
#                     owner = employee if "employee" in locals() else dependent
#                     BankAccount.objects.create(
#                         employee=owner if isinstance(owner, Employee) else None,
#                         dependent=owner if isinstance(owner, Dependent) else None,
#                         bank=bank,
#                         bank_account_type=bank_account_type,
#                         account_number=(
#                             str(int(row["شماره حساب"]))
#                             if pd.notna(row["شماره حساب"])
#                             else None
#                         ),
#                         sheba_number=(
#                             str(int(row["شماره شبا"]))
#                             if pd.notna(row["شماره شبا"])
#                             else None
#                         ),
#                         # card_number اگر باشه
#                     )

#                 # ایجاد ContactInfo (شماره تلفن جدا اگر باشه)
#                 phone = (
#                     str(int(row["شماره تلفن"])) if pd.notna(row["شماره تلفن"]) else None
#                 )
#                 if phone:
#                     owner = employee if "employee" in locals() else dependent
#                     ContactInfo.objects.create(
#                         employee=owner if isinstance(owner, Employee) else None,
#                         dependent=owner if isinstance(owner, Dependent) else None,
#                         phone_number=phone,
#                     )

#             except Exception as e:
#                 created_count["errors"].append(f"خطا در ردیف {index}: {str(e)}")
#                 raise  # برای rollback transaction

#     return created_count


def import_from_excel(excel_file):

    errors = []
    employee_count = 0
    dependent_count = 0

    dtype_spec = {
        "کد ملی": str,
        "کد ملی بیمه شده اصلی": str,
    }

    # Read the Excel sheets
    df_insured = pd.read_excel(
        excel_file,
        sheet_name="لیست بیمه شدگان",
        header=0,
        dtype=dtype_spec,
        keep_default_na=False,
    )

    # Clean column names (remove any extra spaces)
    df_insured.columns = [col.strip() for col in df_insured.columns]

    required_columns = {
        "کد ملی",
        "نام",
        "نام خانوادگی",
        "کد نسبت با بیمه شده اصلی",
        "کد ملی بیمه شده اصلی",
    }
    missing_cols = required_columns - set(df_insured.columns)
    if missing_cols:
        errors.append(f"فیلدهای اجباری: {', '.join(missing_cols)}")
        return {
            "employees": 0,
            "dependents": 0,
            "errors": errors,
        }

    # Function to parse Persian date to Gregorian date
    def parse_persian_date(date_str):
        if pd.isna(date_str) or not date_str:
            return None
        try:
            year, month, day = map(int, date_str.split("/"))
            from jdatetime import date as jdate

            return jdate(year, month, day).togregorian()
        except:
            return None

    #####################################
    # Step 1: Import Employees (where relative_code == 1)
    employees_df = df_insured[df_insured["کد نسبت با بیمه شده اصلی"] == 1]
    for _, row in employees_df.iterrows():
        national_id = str(row.get("کد ملی", "")).strip()
        if len(national_id) < 10:
            print(national_id)

        if not national_id:
            errors.append(f"ردیف بدون کد ملی پرش شد.")
            continue

        first_name = row.get("نام", "").strip()
        if not first_name:
            errors.append(f"نام خالی برای {national_id}")
            continue

        last_name = row.get("نام خانوادگی", "").strip()
        if not last_name:
            errors.append(f"نام خانوادگی خالی برای {national_id}")
            continue

        # Prepare defaults for Employee
        defaults = {
            "first_name": first_name,
            "last_name": last_name,
        }

        if "نام پدر" in df_insured.columns:
            defaults["father_name"] = (
                row["نام پدر"].strip() if pd.notna(row["نام پدر"]) else None
            )

        if "تاریخ تولد" in df_insured.columns:
            defaults["birth_date"] = (
                parse_persian_date(row["تاریخ تولد"])
                if pd.notna(row["تاریخ تولد"])
                else None
            )

        if "شماره شناسنامه" in df_insured.columns:
            defaults["birth_certificate_number"] = (
                str(row["شماره شناسنامه"]).strip()
                if pd.notna(row["شماره شناسنامه"])
                else None
            )

        if "موبایل" in df_insured.columns:
            defaults["phone_number"] = (
                str(row["موبایل"]).strip() if pd.notna(row["موبایل"]) else ""
            )

        if "کد پرسنلی بیمه شده اصلی" in df_insured.columns:
            defaults["personnel_code"] = (
                str(row["کد پرسنلی بیمه شده اصلی"]).strip()
                if pd.notna(row["کد پرسنلی بیمه شده اصلی"])
                else None
            )

        # Foreign keys - only if column exists
        if "کد جنسیت" in df_insured.columns and pd.notna(row["کد جنسیت"]):
            try:
                defaults["gender"] = Gender.objects.get(code=int(row["کد جنسیت"]))
            except ObjectDoesNotExist:
                errors.append(
                    f"جنسیت با کد {row['کد جنسیت']} پیدا نشد برای {national_id}"
                )

        if "کد وضعیت تکفل" in df_insured.columns and pd.notna(row["کد وضعیت تکفل"]):
            try:
                defaults["dependency_status"] = DependencyStatus.objects.get(
                    code=int(row["کد وضعیت تکفل"])
                )
            except ObjectDoesNotExist:
                errors.append(
                    f"وضعیت تکفل با کد {row['کد وضعیت تکفل']} پیدا نشد برای {national_id}"
                )

        if "کد وضعیت تأهل" in df_insured.columns and pd.notna(row["کد وضعیت تأهل"]):
            try:
                defaults["marital_status"] = MaritalStatus.objects.get(
                    code=int(row["کد وضعیت تأهل"])
                )
            except ObjectDoesNotExist:
                errors.append(
                    f"وضعیت تأهل با کد {row['کد وضعیت تأهل']} پیدا نشد برای {national_id}"
                )

        # Update or create Employee
        try:
            with transaction.atomic():
                employee, created = Employee.objects.update_or_create(
                    national_id=national_id, defaults=defaults
                )
                employee_count += 1

                if created or not (employee.password):

                    print("aaaaaaaaaaaaaaaaaa")

                    def parse_id_list(id_str):
                        """
                        تبدیل رشته آیدی‌ها (مثل '1,2;3' یا ' 4 , 5 ') به لیست اعداد صحیح
                        """
                        if not id_str:
                            return []
                        # جایگزینی نقطه‌ویرگول با کاما و تقسیم
                        parts = [
                            p.strip()
                            for p in id_str.replace(";", ",").split(",")
                            if p.strip()
                        ]
                        ids = []
                        for p in parts:
                            try:
                                ids.append(int(p))
                            except ValueError:
                                return None, f"آیدی نامعتبر: '{p}' (باید عدد صحیح باشد)"
                        return ids, None

                    role_id = str(row["کد نقش"]).strip()
                    if not role_id:
                        errors.append(
                            f"این شخص در سیستم اکانت ندارد و کد نقش هم برای ایشان تعریف نشده {national_id}"
                        )
                        continue

                    role_objs = []
                    role_ids, err = parse_id_list(role_id)
                    if err:
                        errors.append(f"{err}")
                    else:
                        for rid in role_ids:
                            try:
                                role = Role.objects.get(id=rid)
                                role_objs.append(role)
                            except Role.DoesNotExist:
                                errors.append(f"نقش با آیدی {rid} وجود ندارد.")
                            except ValueError:
                                errors.append(f"آیدی نقش {rid} نامعتبر است.")

                    employee.roles.set(role_objs)

                    subdept_objs = []
                    subdepartment_id = str(row["کد زیربخش"]).strip()
                    if not subdepartment_id:
                        errors.append(
                            f"این شخص در سیستم اکانت ندارد و کد زیربخش هم برای ایشان تعریف نشده {national_id}"
                        )
                        continue

                    subdept_ids, err = parse_id_list(subdepartment_id)
                    if err:
                        errors.append(err)
                    else:
                        for sid in subdept_ids:
                            try:
                                subdept = Subdepartment.objects.get(id=sid)
                                subdept_objs.append(subdept)
                            except Subdepartment.DoesNotExist:
                                errors.append(f"زیربخش با آیدی {sid} وجود ندارد.")
                            except ValueError:
                                errors.append(f"آیدی زیربخش {sid} نامعتبر است.")

                    employee.assigned_subdepartments.set(subdept_objs)

                    hashed_password = make_password("123456")

                    employee.password = hashed_password
                    employee.save()

                # Handle Employee_Bimeh - only include fields that exist
                bimeh_defaults = {}

                if "تاریخ استخدام" in df_insured.columns and pd.notna(
                    row["تاریخ استخدام"]
                ):
                    bimeh_defaults["employment_date"] = parse_persian_date(
                        row["تاریخ استخدام"]
                    )

                if (
                    "نوع استخدام" in df_insured.columns
                    and pd.notna(row["نوع استخدام"])
                    and str(row["نوع استخدام"]).strip()
                ):
                    try:
                        bimeh_defaults["employment_type"] = EmploymentType.objects.get(
                            code=int(row["نوع استخدام"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"نوع استخدام نامعتبر برای {national_id}")

                if (
                    "کد گروه" in df_insured.columns
                    and pd.notna(row["کد گروه"])
                    and str(row["کد گروه"]).strip()
                ):
                    try:
                        bimeh_defaults["job_group"] = JobGroup.objects.get(
                            code=int(row["کد گروه"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"گروه شغلی نامعتبر برای {national_id}")

                if (
                    "کد نوع بیمه پایه" in df_insured.columns
                    and pd.notna(row["کد نوع بیمه پایه"])
                    and str(row["کد نوع بیمه پایه"]).strip()
                ):
                    try:
                        bimeh_defaults["base_insurance"] = BaseInsurance.objects.get(
                            code=int(row["کد نوع بیمه پایه"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"بیمه پایه نامعتبر برای {national_id}")

                if (
                    "کد کشور(فقط برای اتباع خارجی)" in df_insured.columns
                    and pd.notna(row["کد کشور(فقط برای اتباع خارجی)"])
                    and str(row["کد کشور(فقط برای اتباع خارجی)"]).strip()
                ):
                    try:
                        bimeh_defaults["country"] = Country.objects.get(
                            code=int(row["کد کشور(فقط برای اتباع خارجی)"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        pass

                if (
                    "کد بیمه گر قبلی" in df_insured.columns
                    and pd.notna(row["کد بیمه گر قبلی"])
                    and str(row["کد بیمه گر قبلی"]).strip()
                ):
                    try:
                        bimeh_defaults["previous_insurer"] = (
                            PreviousInsurer.objects.get(
                                code=int(row["کد بیمه گر قبلی"])
                            )
                        )
                    except (ObjectDoesNotExist, ValueError):
                        pass

                if (
                    "مدت پوشش(ماه)" in df_insured.columns
                    and pd.notna(row["مدت پوشش(ماه)"])
                    and str(row["مدت پوشش(ماه)"]).strip()
                ):
                    try:
                        bimeh_defaults["coverage_duration"] = int(row["مدت پوشش(ماه)"])
                    except ValueError:
                        pass

                if bimeh_defaults:
                    Employee_Bimeh.objects.update_or_create(
                        employee=employee, defaults=bimeh_defaults
                    )

                # Handle BankAccount for Employee - only include fields that exist
                raw_sheba = (
                    str(row["شماره شبا"]).strip()
                    if "شماره شبا" in df_insured.columns and pd.notna(row["شماره شبا"])
                    else None
                )
                if raw_sheba and raw_sheba.upper().startswith("IR"):
                    sheba_number = raw_sheba[2:]
                else:
                    sheba_number = raw_sheba

                raw_account = (
                    str(row["شماره حساب"]).strip()
                    if "شماره حساب" in df_insured.columns
                    and pd.notna(row["شماره حساب"])
                    else None
                )

                bank = None
                if (
                    "کد بانک" in df_insured.columns
                    and pd.notna(row["کد بانک"])
                    and str(row["کد بانک"]).strip()
                ):
                    try:
                        bank = Banks.objects.get(code=int(row["کد بانک"]))
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"بانک نامعتبر برای {national_id}")

                bank_account_type = None
                if (
                    "نوع حساب" in df_insured.columns
                    and pd.notna(row["نوع حساب"])
                    and str(row["نوع حساب"]).strip()
                ):
                    try:
                        bank_account_type = BankAccountType.objects.get(
                            code=int(row["نوع حساب"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"نوع حساب نامعتبر برای {national_id}")

                # فقط بر اساس مالک (employee یا dependent) آپدیت کن، نه شبا
                if (
                    raw_account is not None
                    or sheba_number is not None
                    or bank is not None
                    or bank_account_type is not None
                ):
                    bank_defaults = {}
                    if raw_account is not None:
                        bank_defaults["account_number"] = raw_account
                    if sheba_number is not None:
                        bank_defaults["sheba_number"] = sheba_number
                    if bank is not None:
                        bank_defaults["bank"] = bank
                    if bank_account_type is not None:
                        bank_defaults["bank_account_type"] = bank_account_type

                    try:
                        BankAccount.objects.update_or_create(
                            employee=employee, defaults=bank_defaults
                        )
                    except Exception as e:
                        errors.append(
                            f"خطا در ذخیره حساب بانکی برای {national_id}: {str(e)}"
                        )

                # Handle ContactInfo (if شماره تلفن exists, add as additional contact)
                if (
                    "شماره تلفن" in df_insured.columns
                    and pd.notna(row["شماره تلفن"])
                    and str(row["شماره تلفن"]).strip()
                ):
                    try:
                        ContactInfo.objects.get_or_create(
                            employee=employee,
                            phone_number=str(row["شماره تلفن"]).strip(),
                        )
                    except ValidationError as ve:
                        errors.append(
                            f"خطا در افزودن شماره تلفن برای {national_id}: {ve}"
                        )

        except Exception as e:
            errors.append(f"خطا در پردازش کارمند {national_id}: {str(e)}")

    # Step 2: Import Dependents (relative_code != 1)
    dependents_df = df_insured[df_insured["کد نسبت با بیمه شده اصلی"] != 1]
    missing_employees_count = 0
    for _, row in dependents_df.iterrows():
        national_id = str(row.get("کد ملی", "")).strip()

        if not national_id:
            errors.append(f"ردیف بدون کد ملی پرش شد.")
            continue

        first_name = row.get("نام", "").strip()
        if not first_name:
            errors.append(f"نام خالی برای {national_id}")
            continue

        last_name = row.get("نام خانوادگی", "").strip()
        if not last_name:
            errors.append(f"نام خانوادگی خالی برای {national_id}")
            continue

        employee_national_id = str(row.get("کد ملی بیمه شده اصلی", "")).strip()

        if not employee_national_id:
            errors.append(f"کد ملی بیمه شده اصلی خالی برای وابسته {national_id}")
            continue
        try:
            employee = Employee.objects.get(national_id=employee_national_id)
        except ObjectDoesNotExist:
            missing_employees_count += 1
            errors.append(
                f"کارمند با کد ملی {employee_national_id} برای وابسته {national_id} پیدا نشد."
            )
            continue  # Skip and count missing

        # Prepare defaults for Dependent - only include fields that exist in the Excel
        defaults = {
            "first_name": first_name,
            "last_name": last_name,
        }

        if "نام پدر" in df_insured.columns:
            defaults["father_name"] = (
                row["نام پدر"].strip() if pd.notna(row["نام پدر"]) else ""
            )

        if "تاریخ تولد" in df_insured.columns:
            defaults["birth_date"] = (
                parse_persian_date(row["تاریخ تولد"])
                if pd.notna(row["تاریخ تولد"])
                else None
            )

        if "شماره شناسنامه" in df_insured.columns:
            defaults["birth_certificate_number"] = (
                str(row["شماره شناسنامه"]).strip()
                if pd.notna(row["شماره شناسنامه"])
                else ""
            )

        # Foreign keys - only if column exists
        try:
            defaults["relative_type"] = RelativeType.objects.get(
                code=int(row["کد نسبت با بیمه شده اصلی"])
            )
        except ObjectDoesNotExist:
            errors.append(
                f"نسبت با کد {row.get('کد نسبت با بیمه شده اصلی')} پیدا نشد برای {national_id}"
            )
            continue  # Required, skip if not found
        except ValueError:
            errors.append(f"کد نسبت نامعتبر برای {national_id}")
            continue

        if "کد جنسیت" in df_insured.columns and pd.notna(row["کد جنسیت"]):
            try:
                defaults["gender"] = Gender.objects.get(code=int(row["کد جنسیت"]))
            except ObjectDoesNotExist:
                errors.append(
                    f"جنسیت با کد {row['کد جنسیت']} پیدا نشد برای {national_id}"
                )

        if "کد وضعیت تکفل" in df_insured.columns and pd.notna(row["کد وضعیت تکفل"]):
            try:
                defaults["dependency_status"] = DependencyStatus.objects.get(
                    code=int(row["کد وضعیت تکفل"])
                )
            except ObjectDoesNotExist:
                errors.append(
                    f"وضعیت تکفل با کد {row['کد وضعیت تکفل']} پیدا نشد برای {national_id}"
                )

        if "کد وضعیت تأهل" in df_insured.columns and pd.notna(row["کد وضعیت تأهل"]):
            try:
                defaults["marital_status"] = MaritalStatus.objects.get(
                    code=int(row["کد وضعیت تأهل"])
                )
            except ObjectDoesNotExist:
                errors.append(
                    f"وضعیت تأهل با کد {row['کد وضعیت تأهل']} پیدا نشد برای {national_id}"
                )

        if (
            "کد کشور(فقط برای اتباع خارجی)" in df_insured.columns
            and pd.notna(row["کد کشور(فقط برای اتباع خارجی)"])
            and str(row["کد کشور(فقط برای اتباع خارجی)"]).strip()
        ):
            try:
                defaults["country"] = Country.objects.get(
                    code=int(row["کد کشور(فقط برای اتباع خارجی)"])
                )

            except (ObjectDoesNotExist, ValueError):
                pass

        # Update or create Dependent
        try:
            with transaction.atomic():
                dependent, created = Dependent.objects.update_or_create(
                    employee=employee, national_id=national_id, defaults=defaults
                )
                dependent_count += 1

                # Handle BankAccount for Dependent - only include fields that exist
                raw_sheba = (
                    str(row["شماره شبا"]).strip()
                    if "شماره شبا" in df_insured.columns and pd.notna(row["شماره شبا"])
                    else None
                )
                if raw_sheba and raw_sheba.upper().startswith("IR"):
                    sheba_number = raw_sheba[2:]
                else:
                    sheba_number = raw_sheba

                raw_account = (
                    str(row["شماره حساب"]).strip()
                    if "شماره حساب" in df_insured.columns
                    and pd.notna(row["شماره حساب"])
                    else None
                )

                bank = None
                if (
                    "کد بانک" in df_insured.columns
                    and pd.notna(row["کد بانک"])
                    and str(row["کد بانک"]).strip()
                ):
                    try:
                        bank = Banks.objects.get(code=int(row["کد بانک"]))
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"بانک نامعتبر برای {national_id}")

                bank_account_type = None
                if (
                    "نوع حساب" in df_insured.columns
                    and pd.notna(row["نوع حساب"])
                    and str(row["نوع حساب"]).strip()
                ):
                    try:
                        bank_account_type = BankAccountType.objects.get(
                            code=int(row["نوع حساب"])
                        )
                    except (ObjectDoesNotExist, ValueError):
                        errors.append(f"نوع حساب نامعتبر برای {national_id}")

                # فقط بر اساس مالک (employee یا dependent) آپدیت کن، نه شبا
                if (
                    raw_account is not None
                    or sheba_number is not None
                    or bank is not None
                    or bank_account_type is not None
                ):
                    bank_defaults = {}
                    if raw_account is not None:
                        bank_defaults["account_number"] = raw_account
                    if sheba_number is not None:
                        bank_defaults["sheba_number"] = sheba_number
                    if bank is not None:
                        bank_defaults["bank"] = bank
                    if bank_account_type is not None:
                        bank_defaults["bank_account_type"] = bank_account_type

                    try:
                        BankAccount.objects.update_or_create(
                            dependent=dependent, defaults=bank_defaults
                        )
                    except Exception as e:
                        errors.append(
                            f"خطا در ذخیره حساب بانکی برای {national_id}: {str(e)}"
                        )

                # Handle ContactInfo for Dependent (mobile as primary, تلفن as additional)
                if (
                    "موبایل" in df_insured.columns
                    and pd.notna(row["موبایل"])
                    and str(row["موبایل"]).strip()
                ):
                    try:
                        ContactInfo.objects.get_or_create(
                            dependent=dependent,
                            phone_number=str(row["موبایل"]).strip(),
                        )
                    except ValidationError as ve:
                        errors.append(f"خطا در افزودن موبایل برای {national_id}: {ve}")

                if (
                    "شماره تلفن" in df_insured.columns
                    and pd.notna(row["شماره تلفن"])
                    and str(row["شماره تلفن"]).strip()
                ):
                    try:
                        ContactInfo.objects.get_or_create(
                            dependent=dependent,
                            phone_number=str(row["شماره تلفن"]).strip(),
                        )
                    except ValidationError as ve:
                        errors.append(
                            f"خطا در افزودن شماره تلفن برای {national_id}: {ve}"
                        )
        except Exception as e:
            errors.append(f"خطا در پردازش وابسته {national_id}: {str(e)}")

    if missing_employees_count > 0:
        errors.append(
            f"{missing_employees_count} خانواده برای کارمندان پیدا نشدند (کارمند اصلی موجود نبود)."
        )

    return {
        "employees": employee_count,
        "dependents": dependent_count,
        "errors": errors,
    }


def add_managers(request):
    holdings = Holding.objects.filter().distinct()
    factories = Factory.objects.filter().distinct()
    departments = Department.objects.filter().distinct()
    subdepartments = Subdepartment.objects.filter().distinct()

    for h in holdings:
        manager = h.manager if h.manager else None
        managers = h.managers.distinct()

        if not manager in managers and manager != None:
            h.managers.add(manager)
            h.save()

    for f in factories:
        if f.is_committee:
            continue

        manager = f.manager if f.manager else None
        managers = f.managers.distinct()

        if not manager in managers and manager != None:
            f.managers.add(manager)
            f.save()

    for d in departments:
        if d.is_committee:
            continue

        manager = d.manager if d.manager else None
        managers = d.managers.distinct()

        if not manager in managers and manager != None:
            d.managers.add(manager)
            d.save()

    for s in subdepartments:
        if s.is_committee:
            continue

        supervisor = s.supervisor if s.supervisor else None
        supervisors = s.supervisors.distinct()

        if not supervisor in supervisors and supervisor != None:
            s.supervisors.add(supervisor)
            s.save()

    # return redirect("users:dashboard")
    return redirect("users:landing")
