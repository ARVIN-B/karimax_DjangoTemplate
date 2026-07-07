from django.conf import settings
from django.db.models import Q
from django.utils import timezone
from .models import Notification


# users/context_processors.py
def management_context(request):
    if request.user.is_authenticated:
        return {"management_tree": request.session.get("management_tree", [])}
    return {}


def user_role_context(request):
    """
    متغیرهای نقش و مکان کاربر را از session خوانده و به context سراسری اضافه می‌کند.
    """
    # بررسی کنید که آیا کاربر لاگین کرده است و نقش در session وجود دارد

    current_host = settings.BASE_URL
    current_host = "mymoghadam.ir"

    if not request.user.is_authenticated or "current_role" not in request.session:
        return {}  # اگر لاگین نکرده یا نقش تنظیم نشده، context خالی برمی‌گرداند

    role_name = request.session.get("current_role")

    # تعریف لیست نقش‌های مدیریتی در یک مکان مرکزی
    management_roles = [
        "super_admin",
        "holding_manager",
        "factory_manager",
        "department_manager",
        "supervisor",
    ]

    management_tree = request.session.get("management_tree", [])

    context = {
        "role_name": role_name,
        "management_tree": management_tree,
        "management_roles": management_roles,
        "is_super_admin": role_name == "super_admin",
        "has_management_access": role_name in management_roles,  # متغیر کمکی
        "current_holding_id": request.session.get("current_holding_id"),
        "current_factory_id": request.session.get("current_factory_id"),
        "current_department_id": request.session.get("current_department_id"),
        "current_host": current_host,
    }

    return context


def global_banner(request):
    """
    این پردازشگر یک متن بنر سراسری را در اختیار تمام قالب‌ها قرار می‌دهد.
    شما می‌توانید متن را به‌صورت داینامیک از دیتابیس، تنظیمات، یا هر منطق دیگری بخوانید.
    """

    phone_number = settings.CONTACT_PHONE_NUMBER
    # فرض می‌کنیم متن مورد نظر شما در یک متغیر به نام 'test' از backend می‌آید.
    # می‌توانید اینجا منطق دلخواه خود را پیاده کنید.
    # banner_text = f"در صورت وجود هرگونه مشکل ، لطفا با پشتیبانی تماس حاصل بفرمایید. شماره تماس پشتیبانی : {phone_number}"  # مقدار پیش‌فرض

    # اگر می‌خواهید متن را از تنظیمات Django بخوانید:
    # from django.conf import settings
    # banner_text = getattr(settings, 'GLOBAL_BANNER_TEXT', banner_text)

    # یا از یک مدل:
    # from .models import SiteBanner
    # active_banner = SiteBanner.objects.filter(is_active=True).first()
    # if active_banner:
    #     banner_text = active_banner.text

    return {
        # 'global_banner_text': banner_text
    }


def notification_context(request):
    try:
        role_name = request.session["current_role"]
        holding_id = request.session["current_holding_id"]
        factory_id = request.session["current_factory_id"]
        department_id = request.session["current_department_id"]
        subdepartment_id = request.session["current_subdepartment_id"]
        user = request.user
    except:
        context = {}
        return context

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
                        Q(target_departments__id=department_id)
                    ).distinct()
            else:
                notifications = Notification.objects.filter(
                    Q(target_factories__id=factory_id)
                ).distinct()
        else:
            notifications = Notification.objects.filter(
                Q(target_holdings__id=holding_id)
            ).distinct()
    else:
        notifications = Notification.objects.all().distinct()

    now = timezone.now()

    active_notifications = notifications.filter(is_active=True).filter(
        Q(expires_at__isnull=True) | Q(expires_at__gte=now)
    )

    expired_notifications = notifications.filter(
        expires_at__isnull=False,
        expires_at__lt=now,
    )

    active_seen_notifications = active_notifications.filter(
        reads__employee=user
    ).distinct()

    active_unseen_notifications = active_notifications.exclude(
        reads__employee=user
    ).distinct()

    # number_of_critical_priority_notifications = notifications.filter(
    #     Q(priority="critical") | Q(priority="high")
    # ).count()

    # number_of_low_priority_notifications = notifications.filter(
    #     Q(priority="medium") | Q(priority="low")
    # ).count()

    number_of_unseen_critical_priority_notifications = (
        active_unseen_notifications.filter(Q(priority="critical")).count()
    )

    number_of_unseen_high_priority_notifications = active_unseen_notifications.filter(
        Q(priority="high")
    ).count()

    number_of_unseen_medium_priority_notifications = active_unseen_notifications.filter(
        Q(priority="medium")
    ).count()

    number_of_unseen_low_priority_notifications = active_unseen_notifications.filter(
        Q(priority="low")
    ).count()

    if number_of_unseen_critical_priority_notifications:
        badge_count = number_of_unseen_critical_priority_notifications
        badge_level = "critical"
    elif number_of_unseen_high_priority_notifications:
        badge_count = number_of_unseen_high_priority_notifications
        badge_level = "high"
    elif number_of_unseen_medium_priority_notifications:
        badge_count = number_of_unseen_medium_priority_notifications
        badge_level = "medium"
    else:
        badge_count = number_of_unseen_low_priority_notifications
        badge_level = "low" if badge_count else None

    context = {
        "notifications": notifications,
        # "number_of_critical_priority_notifications": number_of_critical_priority_notifications,
        # "number_of_low_priority_notifications": number_of_low_priority_notifications,
        # "number_of_unseen_critical_priority_notifications": number_of_unseen_critical_priority_notifications,
        # "number_of_unseen_high_priority_notifications": number_of_unseen_high_priority_notifications,
        # "number_of_unseen_medium_priority_notifications": number_of_unseen_medium_priority_notifications,
        # "number_of_unseen_low_priority_notifications": number_of_unseen_low_priority_notifications,
        "notification_badge_count": badge_count,
        "notification_badge_level": badge_level,
        "active_seen_notifications": active_seen_notifications,
        "active_unseen_notifications": active_unseen_notifications,
        "expired_notifications": expired_notifications,
    }

    return context
