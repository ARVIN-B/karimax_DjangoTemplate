from django.conf import settings

# users/context_processors.py
def management_context(request):
    if request.user.is_authenticated:
        return {
            'management_tree': request.session.get('management_tree', [])
        }
    return {}


def user_role_context(request):
    """
    متغیرهای نقش و مکان کاربر را از session خوانده و به context سراسری اضافه می‌کند.
    """
    # بررسی کنید که آیا کاربر لاگین کرده است و نقش در session وجود دارد
    if not request.user.is_authenticated or 'current_role' not in request.session:
        return {}  # اگر لاگین نکرده یا نقش تنظیم نشده، context خالی برمی‌گرداند

    role_name = request.session.get('current_role')

    # تعریف لیست نقش‌های مدیریتی در یک مکان مرکزی
    management_roles = ["super_admin", "holding_manager", "factory_manager", "department_manager", "supervisor"]

    management_tree = request.session.get('management_tree', [])

    context = {
        'role_name': role_name,
        'management_tree': management_tree,
        'management_roles': management_roles,
        'is_super_admin': role_name == "super_admin",
        'has_management_access': role_name in management_roles,  # متغیر کمکی

        'current_holding_id': request.session.get('current_holding_id'),
        'current_factory_id': request.session.get('current_factory_id'),
        'current_department_id': request.session.get('current_department_id'),
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