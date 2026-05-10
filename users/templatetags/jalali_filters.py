# users/templatetags/jalali_filters.py
import jdatetime
from django import template
from django.utils import timezone

register = template.Library()


@register.filter(name="jalali_date")
def jalali_date(value, format_str="%Y/%m/%d"):
    """
    Convert a datetime object to Jalali (Shamsi) date string.
    Default format: 1402/06/15
    """
    if not value:
        return ""
    # تبدیل به زمان محلی (Asia/Tehran)
    local_dt = timezone.localtime(value)
    # تبدیل میلادی به شمسی
    jalali_dt = jdatetime.datetime.fromgregorian(datetime=local_dt)
    # فرمت‌دهی با strftime
    return jalali_dt.strftime(format_str)
