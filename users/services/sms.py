import logging
from typing import Iterable

import requests
from django.conf import settings

logger = logging.getLogger(__name__)

PARSGREEN_SEND_SMS_URL = "https://sms.parsgreen.ir/Apiv2/Message/SendSms"
PARSGREEN_DEFAULT_API_KEY = "0E1A21CA-3729-40DD-A37C-387E3CB5982C"


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


def _build_sms_body(employee, description: str) -> str:
    """
    ساخت متن پیامک.
    description متن داینامیک پیام است.
    """

    full_name = (
        employee.get_full_name().strip()
        or f"{employee.first_name} {employee.last_name}".strip()
        or "همکار گرامی"
    )

    personnel_number = getattr(employee, "personnel_number", None) or getattr(
        employee, "username", ""
    )

    return f"""همکار گرامی {full_name}
        کد ملی: {employee.national_id}

        🔔 {description}"""


def _send_sms(mobile: str, message: str):
    api_key = (
        getattr(settings, "PARSGREEN_SMS_API_KEY", "") or PARSGREEN_DEFAULT_API_KEY
    ).strip()

    sms_number = (
        getattr(settings, "PARSGREEN_SMS_NUMBER", "")
        or getattr(settings, "PARSGREEN_SMS_SENDER", "")
        or ""
    ).strip()

    if not api_key:
        return False, "PARSGREEN_SMS_API_KEY تنظیم نشده است.", {}

    if not sms_number:
        return False, "PARSGREEN_SMS_NUMBER تنظیم نشده است.", {}

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
            timeout=20,
        )
    except requests.RequestException as exc:
        return (
            False,
            "خطا در ارتباط با سامانه پیامکی.",
            {
                "exception": str(exc),
            },
        )

    try:
        data = response.json()
    except ValueError:
        data = {}

    success = (
        response.status_code < 400
        and bool(data.get("R_Success"))
        and int(data.get("R_Code", -1)) == 0
    )

    if success:
        return True, "ارسال شد.", data

    return (
        False,
        data.get("R_Message") or "ارسال ناموفق بود.",
        data,
    )


def send_sms_to_employees(employees, message: str):
    """
    ارسال پیامک به یک یا چند Employee.

    Parameters
    ----------
    employees:
        Employee | QuerySet[Employee] | list[Employee] | tuple[Employee]

    message:
        فقط متن اصلی پیام.
        اطلاعات کاربر به صورت خودکار به ابتدای پیام اضافه می‌شود.
    """

    if employees is None:
        return {
            "success_count": 0,
            "failed_count": 0,
            "results": [],
        }

    if not isinstance(employees, Iterable) or isinstance(employees, (str, bytes)):
        employees = [employees]

    results = []
    seen_numbers = set()

    for employee in employees:

        mobile = _normalize_mobile_number(getattr(employee, "phone_number", None))

        if not mobile:
            results.append(
                {
                    "employee_id": getattr(employee, "id", None),
                    "employee": str(employee),
                    "mobile": None,
                    "success": False,
                    "message": "شماره موبایل نامعتبر است.",
                }
            )
            continue

        if mobile in seen_numbers:
            continue

        seen_numbers.add(mobile)

        sms_body = _build_sms_body(
            employee=employee,
            description=message,
        )

        success, provider_message, provider_data = _send_sms(
            mobile=mobile,
            message=sms_body,
        )

        results.append(
            {
                "employee_id": getattr(employee, "id", None),
                "employee": str(employee),
                "mobile": mobile,
                "success": success,
                "message": provider_message,
                "provider_data": provider_data,
            }
        )

        logger.info(
            "SMS | employee=%s | mobile=%s | success=%s",
            getattr(employee, "id", None),
            mobile,
            success,
        )

    return {
        "success_count": sum(r["success"] for r in results),
        "failed_count": sum(not r["success"] for r in results),
        "results": results,
    }
