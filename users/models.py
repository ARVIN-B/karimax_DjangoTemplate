from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone
import random
import string
from django.contrib.auth.hashers import make_password
from django.core.files.base import ContentFile
from django.db.models.signals import post_save
from django.dispatch import receiver
from io import BytesIO
from pydub import AudioSegment
import os
import mimetypes
from django.db import transaction
from sympy import factor

from django.core.exceptions import ValidationError
from django.utils.translation import gettext_lazy as _
import jdatetime
from datetime import date, time, datetime, timedelta
from django.apps import AppConfig

from jdatetime import date as jdate


default_close_food_res_time_H = 10
default_close_food_res_time_M = 00

start_today_food_comment_time_H = 10
start_today_food_comment_time_M = 00


def generate_random_password(length=12):
    characters = string.ascii_letters + string.digits + "!@#$%^&*"
    return "".join(random.choice(characters) for _ in range(length))


def participation_upload_path(instance, filename):
    date_str = timezone.now().strftime("%Y/%m/%d")
    return f"participations/{date_str}/{filename}"


class Holding(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام هلدینگ")
    location = models.CharField(max_length=200, verbose_name="مکان")
    manager = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="managed_holdings",
        verbose_name="مدیر هلدینگ",
    )
    managers = models.ManyToManyField(
        "Employee",
        blank=True,
        related_name="managed_holdings_m2m",
        verbose_name="مدیران هلدینگ",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")

    class Meta:
        verbose_name = "هلدینگ"
        verbose_name_plural = "هلدینگ‌ها"

    def __str__(self):
        return self.name


class Factory(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام کارخانه")
    location = models.CharField(max_length=200, verbose_name="مکان")
    manager = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="managed_factories",
        verbose_name="مدیر کارخانه",
    )
    managers = models.ManyToManyField(
        "Employee",
        blank=True,
        related_name="managed_factories_m2m",
        verbose_name="مدیران کارخانه",
    )
    holding = models.ForeignKey(
        Holding,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="factories",
        verbose_name="هلدینگ",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")
    is_committee = models.BooleanField(default=False, verbose_name="کمیته است؟")
    linked_factory = models.ForeignKey(
        "self",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name="کارخانه لینک شده",
    )
    close_food_res_time_H = models.IntegerField(
        default=10, verbose_name="ساعت بسته شدن مهلت رزرو غذا در این کارخانه"
    )
    close_food_res_time_M = models.IntegerField(
        default=0, verbose_name="دقیقه بسته شدن مهلت رزرو غذا در این کارخانه"
    )

    class Meta:
        verbose_name = "کارخانه"
        verbose_name_plural = "کارخانه‌ها"

    def __str__(self):
        return self.name

    def clean(self):
        """
        اعتبارسنجی ساعت و دقیقه زمان بسته شدن رزرو
        """
        errors = {}

        # بررسی ساعت
        if not (0 <= self.close_food_res_time_H < 24):
            errors["close_food_res_time_H"] = ValidationError(
                _("ساعت باید بین 0 تا 23 باشد."), code="invalid_hour"
            )

        # بررسی دقیقه
        if not (0 <= self.close_food_res_time_M < 60):
            errors["close_food_res_time_M"] = ValidationError(
                _("دقیقه باید بین ۰ تا ۵۹ باشد."), code="invalid_minute"
            )

        if errors:
            raise ValidationError(errors)

    def save(self, *args, **kwargs):
        # قبل از ذخیره، اعتبارسنجی را اجرا می‌کنیم
        self.full_clean()  # ← این خط مهم است
        super().save(*args, **kwargs)


class Department(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام بخش")
    factory = models.ForeignKey(
        Factory,
        on_delete=models.CASCADE,
        related_name="departments",
        verbose_name="کارخانه",
    )
    manager = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="managed_departments",
        verbose_name="مدیر بخش",
    )
    managers = models.ManyToManyField(
        "Employee",
        blank=True,
        related_name="managed_departments_m2m",
        verbose_name="مدیران بخش",
    )
    manager_2 = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="co_managed_departments_2",
        verbose_name="مدیر دوم (کمیته)",
    )
    manager_3 = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="co_managed_departments_3",
        verbose_name="مدیر سوم (کمیته)",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")

    is_committee = models.BooleanField(default=False, verbose_name="کمیته است؟")
    linked_factory = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name="کارخانه لینک شده",
    )
    is_self = models.BooleanField(default=False, verbose_name="سلف است؟")

    class Meta:
        verbose_name = "بخش"
        verbose_name_plural = "بخش‌ها"

    def __str__(self):
        return (
            f"{'[رستوران] ' if self.is_self else ''}{self.name} - {self.factory.name}"
        )

    def clean(self):
        if self.is_self:
            if self.pk:  # در حالت ویرایش
                if (
                    Department.objects.filter(factory=self.factory, is_self=True)
                    .exclude(pk=self.pk)
                    .exists()
                ):
                    raise ValidationError(
                        "در هر کارخانه فقط یک بخش می‌تواند به عنوان رستوران (سلف) علامت‌گذاری شود."
                    )
            else:  # در حالت ایجاد
                if Department.objects.filter(
                    factory=self.factory, is_self=True
                ).exists():
                    raise ValidationError(
                        "در این کارخانه قبلاً یک رستوران تعریف شده است."
                    )

        if self.is_committee:
            if not (self.manager and self.manager_2 and self.manager_3):
                raise ValidationError(
                    "هنگام فعال بودن 'کمیته'، هر سه مدیر باید انتخاب شوند."
                )

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)


class Subdepartment(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام زیربخش")
    department = models.ForeignKey(
        Department,
        on_delete=models.CASCADE,
        related_name="subdepartments",
        verbose_name="بخش",
    )
    supervisor = models.ForeignKey(
        "Employee",
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="supervised_subdepartments",
        verbose_name="سرپرست زیربخش",
    )
    supervisors = models.ManyToManyField(
        "Employee",
        blank=True,
        related_name="supervised_subdepartments_m2m",
        verbose_name="سرپرستان زیربخش",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")

    is_committee = models.BooleanField(default=False, verbose_name="کمیته است؟")
    linked_factory = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name="کارخانه لینک شده",
    )
    is_restaurant = models.BooleanField(default=False, verbose_name="رستوران سلف است؟")

    class Meta:
        verbose_name = "زیربخش"
        verbose_name_plural = "زیربخش‌ها"

    def __str__(self):
        return f"{self.name} - {self.department.name} ({self.department.factory.name})"


class Role(models.Model):
    name = models.CharField(max_length=50, unique=True, verbose_name="نام نقش")
    description = models.TextField(blank=True, verbose_name="توضیحات")
    permissions = models.JSONField(default=dict, blank=True, verbose_name="مجوزها")

    class Meta:
        verbose_name = "نقش"
        verbose_name_plural = "نقش‌ها"

    def get_name_display(self):
        DISPLAY_CHOICES = {
            "super_admin": ("#0000FF", "مدیر کل"),
            "holding_manager": ("#0000FF", "مدیر هلدینگ"),
            "factory_manager": ("#FF4500", "مدیر کارخانه"),
            "department_manager": ("#006400", "مدیر بخش"),
            "supervisor": ("#FFA500", "سرپرست"),
            "employee": ("#808080", "پرسنل"),
        }
        return DISPLAY_CHOICES.get(self.name, ("#000000", self.name))

    def __str__(self):
        return self.name


class PermissionLevel(models.Model):
    role = models.OneToOneField(
        Role,
        on_delete=models.CASCADE,
        related_name="permission_level",
        verbose_name="نقش",
    )
    can_manage_users = models.BooleanField(default=False, verbose_name="مدیریت کاربران")
    can_evaluate = models.BooleanField(default=False, verbose_name="ارزیابی پرسنل")
    can_view_reports = models.BooleanField(default=True, verbose_name="مشاهده گزارش‌ها")
    can_access_all_departments = models.BooleanField(
        default=False, verbose_name="دسترسی به همه بخش‌ها"
    )
    can_access_all_factories = models.BooleanField(
        default=False, verbose_name="دسترسی به همه کارخانه‌ها"
    )  # اضافه کردن با پیش‌فرض False

    class Meta:
        verbose_name = "سطح دسترسی"
        verbose_name_plural = "سطوح دسترسی"

    def __str__(self):
        return f"سطح دسترسی {self.role.name}"

    @receiver(post_save, sender=Role)
    def set_default_permissions(sender, instance, created, **kwargs):
        if created:  # فقط وقتی نقش جدید ساخته می‌شه اجرا بشه
            # چک کن که PermissionLevel برای این نقش وجود نداشته باشه
            if not PermissionLevel.objects.filter(role=instance).exists():
                defaults = {
                    "can_manage_users": instance.name == "super_admin",
                    "can_evaluate": instance.name
                    in [
                        "super_admin",
                        "holding_manager",
                        "factory_manager",
                        "department_manager",
                    ],
                    "can_view_reports": True,
                    "can_access_all_departments": instance.name
                    in ["super_admin", "holding_manager", "factory_manager"],
                    "can_access_all_factories": instance.name
                    in ["super_admin", "holding_manager"],
                }
                PermissionLevel.objects.create(role=instance, **defaults)


class Employee(AbstractUser):

    FOOD_RECEIVER_CHOICES = (
        (0, "تحویل گیرنده نیست"),
        (1, "تحویل گیرنده کارخانه"),
        (2, "تحویل گیرنده هلدینگ"),
    )
    can_reserve_for_others_choices = (
        (0, "اجازه ندارد"),
        (1, "مجاز (با محدودیت)"),
        (2, "مجاز (بدن محدودیت پسنل مقصد)"),
    )
    can_reserve_for_which_day_choices = (
        (0, "فقط همان روز"),
        (1, "مجاز به رزرو برای اینده و گذشته"),
    )

    national_id = models.CharField(max_length=10, unique=True, verbose_name="کد ملی")
    phone_number = models.CharField(
        max_length=15, null=True, blank=True, verbose_name="شماره تماس"
    )
    personnel_code = models.CharField(
        max_length=15, null=True, blank=True, verbose_name="کد پرسنلی"
    )
    roles = models.ManyToManyField(Role, related_name="employees", verbose_name="نقش‌ها")
    assigned_subdepartments = models.ManyToManyField(
        Subdepartment,
        related_name="assigned_employees",
        blank=True,
        verbose_name="زیربخش‌های تخصیص‌یافته",
    )

    can_access_dashboard = models.BooleanField(default=True)
    can_access_all_departments = models.BooleanField(default=False)
    is_first_login = models.BooleanField(default=True, verbose_name="اولین ورود")
    date_joined = models.DateTimeField(default=timezone.now, verbose_name="تاریخ عضویت")
    is_active = models.BooleanField(default=True, verbose_name="فعال")
    last_file_upload = models.DateTimeField(null=True, verbose_name="تاریخ اخرین اپلود")
    day_usage = models.IntegerField(default=0, verbose_name="حجم استفاده اخرین روز")
    unlimit_reservation = models.BooleanField(
        default=False, verbose_name="مجوز رزرو نامحدود"
    )
    is_contractor = models.BooleanField(default=False, verbose_name="آیا پیمانکار است؟")
    # can_reserve_for_others = models.BooleanField(
    #     default=False, verbose_name="مجوز رزرو برای دیگران"
    # )

    guest_limit_reservation = models.IntegerField(
        default=0, verbose_name="محدودیت رزرو مهمان"
    )
    free_limit_reservation = models.IntegerField(
        default=5, verbose_name="محدودیت رزرو آزاد"
    )
    factory_limit_reservation = models.IntegerField(
        default=1, verbose_name="محدودیت رزرو سهمیه ای"
    )

    can_reserve_for_others = models.PositiveSmallIntegerField(
        default=0,
        choices=can_reserve_for_others_choices,
        verbose_name="مجوز رزرو برای دیگران",
    )
    can_reserve_for_which_day = models.PositiveSmallIntegerField(
        default=0,
        choices=can_reserve_for_which_day_choices,
        verbose_name="مجوز رزرو برای تاریخ",
    )
    guest_limit_reservation_for_others = models.IntegerField(
        default=0, verbose_name="محدودیت رزرو مهمان برای دیگران"
    )
    free_limit_reservation_for_others = models.IntegerField(
        default=0, verbose_name="محدودیت رزرو آزاد برای دیگران"
    )
    factory_limit_reservation_for_others = models.IntegerField(
        default=0, verbose_name="محدودیت رزرو سهمیه ای برای دیگران"
    )

    # field1 = models.IntegerField(default=0, verbose_name="فیلد عددی ۱")
    # field2 = models.IntegerField(default=100, verbose_name="فیلد عددی ۲")
    # field3 = models.IntegerField(default=-1, verbose_name="فیلد عددی ۳")
    # flag = models.BooleanField(default=False, verbose_name="فلگ وضعیت")

    # factory_quantity_limit = models.PositiveIntegerField(
    #     default=1, verbose_name="محدودیت روزانه ثبت غذای پرسنلی"
    # )
    # free_quantity_limit = models.PositiveIntegerField(
    #     default=0, verbose_name="محدودیت روزانه ثبت غذای آزاد"
    # )
    # guest_quantity_limit = models.PositiveIntegerField(
    #     default=0, verbose_name="محدودیت روزانه ثبت غذای مهمان"
    # )

    food_receiver_role = models.PositiveSmallIntegerField(
        default=0, choices=FOOD_RECEIVER_CHOICES, verbose_name="نقش تحویل‌گیرنده غذا"
    )

    food_receiver_factory = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="factory_food_receivers",
        verbose_name="کارخانه تحویل‌گیرنده",
    )

    food_receiver_holding = models.ForeignKey(
        Holding,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="holding_food_receivers",
        verbose_name="هلدینگ تحویل‌گیرنده",
    )

    can_serve_foods = models.BooleanField(default=False, verbose_name="اجازه سرو غذا")

    address = models.CharField(
        max_length=1000, null=True, blank=True, verbose_name="آدرس"
    )

    gender = models.ForeignKey(
        "Gender", null=True, blank=True, on_delete=models.PROTECT, verbose_name="جنسیت"
    )

    dependency_status = models.ForeignKey(
        "DependencyStatus",
        null=True,
        blank=True,
        on_delete=models.PROTECT,
        verbose_name="وضعیت تکفل",
    )

    marital_status = models.ForeignKey(
        "MaritalStatus",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        verbose_name="وضعیت تأهل",
    )

    birth_certificate_number = models.CharField(
        max_length=50, null=True, blank=True, verbose_name="شماره شناسنامه"
    )

    birth_date = models.DateField(null=True, blank=True, verbose_name="تاریخ تولد")
    father_name = models.CharField(
        max_length=50, blank=True, null=True, verbose_name="نام پدر"
    )

    factory_bimeh = models.BooleanField(
        default=False, verbose_name="اجازه دانلود اطلاعات بیمه ای پرسنل کارخانه"
    )
    holding_bimeh = models.BooleanField(
        default=False, verbose_name="اجازه دانلود اطلاعات بیمه ای پرسنل هلدینگ"
    )

    can_reserve_management_food = models.BooleanField(
        default=False, verbose_name="اجازه سفارش غذای ویژه"
    )

    # manage employees

    manage_sub_employees = models.BooleanField(
        default=False, verbose_name="مجوز مدیریت پرسنل زیر مجموعه"
    )
    hr_granting_role_limit = models.ForeignKey(
        Role,
        blank=True,
        null=True,
        on_delete=models.PROTECT,
        verbose_name="حد اعطای نقش به پرسنل مربوطه",
    )
    hr_accessible_holdings = models.ManyToManyField(
        Holding,
        related_name="hr_accessible_by",
        blank=True,
        verbose_name="هلدینگ های قابل مدیریت",
    )
    hr_accessible_factories = models.ManyToManyField(
        Factory,
        related_name="hr_accessible_by",
        blank=True,
        verbose_name="کارخانه های قابل مدیریت",
    )
    hr_accessible_departments = models.ManyToManyField(
        Department,
        related_name="hr_accessible_by",
        blank=True,
        verbose_name="بخش های قابل مدیریت",
    )
    hr_accessible_subdepartments = models.ManyToManyField(
        Subdepartment,
        related_name="hr_accessible_by",
        blank=True,
        verbose_name="زیر بخش های قابل مدیریت",
    )
    hr_accessible_employees = models.ManyToManyField(
        "self",
        related_name="hr_accessible_by",
        blank=True,
        verbose_name="پرسنل قابل مدیریت",
    )

    # manage_holdings_members = models.ManyToManyField(
    #     Holding,
    #     related_name="manage_holdings_members",
    #     blank=True,
    #     verbose_name="مدیریت افراد این هلدینگ ها",
    # )

    # manage_factories_members = models.ManyToManyField(
    #     Holding,
    #     related_name="manage_factories_members",
    #     blank=True,
    #     verbose_name="مدیریت افراد این کارخانه ها",
    # )

    # manage_departments_members = models.ManyToManyField(
    #     Holding,
    #     related_name="manage_departments_members",
    #     blank=True,
    #     verbose_name="مدیریت افراد این بخش ها",
    # )

    # manage_subdepartments_members = models.ManyToManyField(
    #     Holding,
    #     related_name="manage_subdepartments_members",
    #     blank=True,
    #     verbose_name="مدیریت افراد این زیر بخش ها",
    # )

    # manage_special_employees = models.ManyToManyField(Employee, related_name="", blank=True, verbose_name="")
    # manage_special_employees = models.ManyToManyField(
    #     "self",
    #     symmetrical=True,
    #     blank=True,
    #     related_name="managed_special_employees",
    #     verbose_name="مدیریت کارکنان ویژه",
    # )

    center_of_charge = models.CharField(
        max_length=200, null=True, blank=True, verbose_name="مرکز هزینه"
    )

    # reporting system
    # can_reserve_for_others_choices = (
    #     (0, "اجازه ندارد"),
    #     (1, "مجاز (با محدودیت)"),
    #     (2, "مجاز (بدن محدودیت پسنل مقصد)"),
    # )
    # can_reserve_for_others = models.PositiveSmallIntegerField(
    #     default=0, choices=can_reserve_for_others_choices, verbose_name="مجوز رزرو برای دیگران"
    # )

    USERNAME_FIELD = "national_id"
    REQUIRED_FIELDS = ["first_name", "last_name", "phone_number"]

    class Meta:
        verbose_name = "کارمند"
        verbose_name_plural = "کارمندان"

    def __str__(self):
        return f"{self.first_name} {self.last_name} - {self.national_id}"

    def save(self, *args, **kwargs):
        if not self.username:
            self.username = self.national_id
        if not self.username:
            raise ValueError("کد ملی (national_id) باید پر باشد برای ست username.")
        super().save(*args, **kwargs)

    def clean(self):
        super().clean()

        # اگر نقش = عادی → نباید کارخانه یا هلدینگ ست شده باشد
        if self.food_receiver_role == 0:
            if self.food_receiver_factory or self.food_receiver_holding:
                raise ValidationError(
                    "برای نقش عادی نباید کارخانه یا هلدینگ انتخاب شود."
                )

        # اگر نقش = تحویل گیرنده کارخانه → فقط کارخانه باید انتخاب شود
        if self.food_receiver_role == 1:
            if not self.food_receiver_factory:
                raise ValidationError(
                    "لطفاً کارخانه مرتبط با تحویل‌گیرنده را انتخاب کنید."
                )
            if self.food_receiver_holding:
                raise ValidationError("تحویل‌گیرنده کارخانه نمی‌تواند هلدینگ داشته باشد.")

        # اگر نقش = تحویل گیرنده هلدینگ → فقط هلدینگ باید انتخاب شود
        if self.food_receiver_role == 2:
            if not self.food_receiver_holding:
                raise ValidationError(
                    "لطفاً هلدینگ مرتبط با تحویل‌گیرنده را انتخاب کنید."
                )
            if self.food_receiver_factory:
                raise ValidationError("تحویل‌گیرنده هلدینگ نمی‌تواند کارخانه داشته باشد.")

    @property
    def full_name(self):
        return f"{self.first_name} {self.last_name}"


class Participation(models.Model):
    ITEM_TYPES = (
        ("performance_file", "ارسال فایل عملکرد"),
        ("work_experience", "ارسال تجربیات کاری"),
        ("meeting_minutes", "صورت جلسات"),
        ("suggestions", "پیشنهادات"),
        ("critiques", "انتقادات"),
    )
    STATUS_CHOICES = (
        ("pending", "در انتظار"),
        ("user_review", "در انتظار بررسی کاربر"),
        ("supervisor_review", "در انتظار تأیید سرپرست"),
        ("manager_review", "در انتظار تأیید مدیر بخش"),
        ("factory_manager_review", "در انتظار تأیید مدیر کارخانه"),
        ("approved", "تأیید شده"),
        ("rejected", "رد شده"),
    )

    user = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name="participations",
        verbose_name="کارمند",
    )
    item_type = models.CharField(
        max_length=50, choices=ITEM_TYPES, verbose_name="نوع ایتم"
    )
    title = models.CharField(max_length=200, verbose_name="عنوان")
    description = models.TextField(verbose_name="توضیحات")
    attachment = models.FileField(
        upload_to=participation_upload_path, verbose_name="پیوست", blank=True, null=True
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ارسال")
    file_size = models.PositiveIntegerField(
        verbose_name="حجم فایل (بایت)", null=True, blank=True
    )
    text_content = models.TextField(blank=True, null=True, verbose_name="متن")
    summarized_content = models.TextField(
        blank=True, null=True, verbose_name="محتوای خلاصه شده"
    )
    orginal_content = models.TextField(
        blank=True, null=True, verbose_name="متن اصلی استخراج شده"
    )
    count_sumerized = models.IntegerField(
        blank=True, null=True, verbose_name="تعداد دفعات خلاصه شده"
    )

    status = models.CharField(
        max_length=30, choices=STATUS_CHOICES, default="pending", verbose_name="وضعیت"
    )
    feedback = models.TextField(
        default="بدون فیدبک", blank=False, null=False, verbose_name="فیدبک رد شدن"
    )
    is_finalized = models.BooleanField(default=False, verbose_name="تأیید نهایی کاربر")

    return_count = models.IntegerField(
        default=0, verbose_name="تعداد دفعات برگردانده  شده"
    )

    is_audio = models.BooleanField(
        default=False, verbose_name="فایل قابل تبدیل به متن است؟"
    )

    holding = models.ForeignKey(
        Holding,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="participations",
        verbose_name="هلدینگ مرتبط",
    )

    factory = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="factory_participations",
        verbose_name="کارخانه مرتبط",
    )

    department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="department_participations",
        verbose_name="بخش مرتبط",
    )

    subdepartment = models.ForeignKey(
        Subdepartment,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="subdepartment_participations",
        verbose_name="زیربخش مرتبط",
    )

    role_name = models.CharField(
        max_length=200, null=True, blank=True, verbose_name="نقش کاربر"
    )

    # جدید: فلگ کمیته
    is_committee = models.BooleanField(default=False, verbose_name="کمیته است؟")
    # سه فیلد برای نظرات مدیران کمیته
    manager_feedback = models.TextField(
        blank=True, null=True, verbose_name="نظر مدیر اول"
    )
    manager_2_feedback = models.TextField(
        blank=True, null=True, verbose_name="نظر مدیر دوم"
    )
    manager_3_feedback = models.TextField(
        blank=True, null=True, verbose_name="نظر مدیر سوم"
    )

    supervisor_feedback = models.TextField(
        blank=True, null=True, verbose_name="نظر سرپرست"
    )

    holding_committee = models.ForeignKey(
        Holding,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="committee_participations",  # کمیته
        verbose_name="هلدینگ کمیته مرتبط",
    )

    factory_committee = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="committee_factory_participations",  # کمیته
        verbose_name="کارخانه کمیته مرتبط",
    )

    department_committee = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="committee_department_participations",  # کمیته
        verbose_name="بخش کمیته مرتبط",
    )

    subdepartment_committee = models.ForeignKey(
        Subdepartment,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name="committee_subdepartment_participations",  # کمیته
        verbose_name="زیربخش کمیته مرتبط",
    )

    manager_status = models.CharField(
        blank=True,
        null=True,
        max_length=30,
        choices=STATUS_CHOICES,
        verbose_name="وضعیت مدیر کمیته 1",
    )
    manager_2_status = models.CharField(
        blank=True,
        null=True,
        max_length=30,
        choices=STATUS_CHOICES,
        verbose_name="وضعیت مدیر کمیته 2",
    )
    manager_3_status = models.CharField(
        blank=True,
        null=True,
        max_length=30,
        choices=STATUS_CHOICES,
        verbose_name="وضعیت مدیر کمیته 3",
    )

    supervisor_status = models.CharField(
        blank=True,
        null=True,
        max_length=30,
        choices=STATUS_CHOICES,
        verbose_name="وضعیت سرپرست کمیته",
    )

    class Meta:
        verbose_name = "مشارکت"
        verbose_name_plural = "مشارکت‌ها"

    def __str__(self):
        return f"{self.title} - {self.user.full_name} ({self.role_name if self.role_name else 'نامشخص'})"


class Evaluation(models.Model):
    TIME_PERIODS = (
        ("daily", "روزانه"),
        ("weekly", "هفتگی"),
        ("monthly", "ماهانه"),
        ("yearly", "سالانه"),
    )
    user = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name="user_evaluations",
        verbose_name="کارمند",
    )
    period = models.CharField(
        max_length=20, choices=TIME_PERIODS, verbose_name="بازه زمانی"
    )
    participation_count = models.PositiveIntegerField(
        default=0, verbose_name="تعداد مشارکت‌ها"
    )
    audio_count = models.PositiveIntegerField(
        default=0, verbose_name="تعداد فایل‌های صوتی"
    )
    score = models.FloatField(default=0.0, verbose_name="امتیاز کلی")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ارزیابی")

    class Meta:
        verbose_name = "ارزیابی مشارکتی"
        verbose_name_plural = "ارزیابی‌های مشارکتی"
        unique_together = ("user", "period", "created_at")

    def __str__(self):
        return f"ارزیابی {self.user.full_name} - {self.get_period_display()}"

    def calculate_score(self):
        base_score = self.participation_count * 10
        audio_bonus = self.audio_count * 5
        return base_score + audio_bonus


@receiver(post_save, sender=Participation)
def handle_participation_update(sender, instance, created, **kwargs):
    if created and instance.attachment:
        # چک نوع فایل
        original_path = instance.attachment.path
        mime_type, _ = mimetypes.guess_type(original_path)

        if (
            mime_type
            and mime_type.startswith("audio/")
            and not original_path.lower().endswith(".mp3")
        ):
            # تبدیل فایل صوتی به MP3
            try:
                audio = AudioSegment.from_file(original_path)
                buffer = BytesIO()
                audio.export(buffer, format="mp3")
                buffer.seek(0)

                # استفاده از نام فایل اصلی با پسوند mp3
                new_filename = (
                    os.path.splitext(os.path.basename(original_path))[0] + ".mp3"
                )
                instance.attachment.save(
                    new_filename, ContentFile(buffer.read()), save=False
                )

                if os.path.exists(original_path):
                    os.remove(original_path)

                instance.file_size = instance.attachment.size
                instance.save()

                # print(f"✅ فایل صوتی تبدیل شد: {new_filename}")
            except Exception as e:
                print(f"❌ خطا در تبدیل فایل صوتی: {e}")
        elif mime_type and (
            mime_type.startswith("image/")
            or mime_type
            == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            or mime_type == "text/plain"
            or mime_type.startswith("video/")
            or mime_type == "application/pdf"
        ):
            print(
                f"⚠️ فایل مجاز (عکس، ورد، متن، ویدئو، PDF) شناسایی شد: {original_path} - بدون تغییر ذخیره شد."
            )
        else:
            print(
                f"⚠️ نوع فایل ناشناخته یا غیرمجاز: {original_path} - بدون تغییر ذخیره شد."
            )

        with transaction.atomic():
            # آپدیت file_size (اگر لازم باشه، قبلاً ست شده)
            instance.file_size = instance.attachment.size
            instance.save(update_fields=["file_size"])  # فقط file_size رو آپدیت کنید

            # اضافه کردن حجم به day_usage کاربر (با ریست روزانه)
            employee = instance.user
            today = timezone.now()
            if (
                employee.last_file_upload
                and employee.last_file_upload.date() != today.date()
            ):
                employee.day_usage = 0  # ریست برای روز جدید

            employee.day_usage += instance.file_size
            employee.last_file_upload = today
            employee.save(update_fields=["day_usage", "last_file_upload"])

        # به‌روزرسانی ارزیابی
        user = instance.user
        current_month = timezone.now().replace(
            day=1, hour=0, minute=0, second=0, microsecond=0
        )

        participations = Participation.objects.filter(
            user=user,
            created_at__month=current_month.month,
            created_at__year=current_month.year,
        )
        participation_count = participations.count()
        audio_count = participations.filter(item_type="performance_file").count()

        evaluation, created = Evaluation.objects.get_or_create(
            user=user,
            period="monthly",
            defaults={
                "participation_count": participation_count,
                "audio_count": audio_count,
                "score": 0.0,
            },
        )

        evaluation.participation_count = participation_count
        evaluation.audio_count = audio_count
        evaluation.score = evaluation.calculate_score()
        evaluation.save()


class UsersConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "users"


class FoodItem(models.Model):
    name = models.CharField(max_length=150, verbose_name="نام غذا")
    factory_price = models.PositiveIntegerField(default=0, verbose_name="قیمت کارخانه")
    free_price = models.PositiveIntegerField(default=0, verbose_name="قیمت آزاد")
    guest_price = models.PositiveIntegerField(default=0, verbose_name="قیمت غذای مهمان")
    price = models.PositiveIntegerField(default=0, verbose_name="قیمت")
    is_active = models.BooleanField(default=True, verbose_name="فعال")
    is_management_food = models.BooleanField(default=False, verbose_name="غذای مدریتی")

    class Meta:
        verbose_name = "غذا"
        verbose_name_plural = "بانک غذاها"
        ordering = ["name"]

    def __str__(self):
        return f"{self.name} ({self.factory_price:,} ریال)"


class WeeklyMenu(models.Model):
    restaurant = models.ForeignKey(
        Subdepartment,
        on_delete=models.CASCADE,
        limit_choices_to={"is_restaurant": True},
        related_name="weekly_menus",
        verbose_name="رستوران",
    )
    week_start_date = models.DateField(verbose_name="شروع هفته (شنبه)")  # تاریخ شنبه
    created_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True, verbose_name="منوی فعال")

    class Meta:
        unique_together = ("restaurant", "week_start_date")
        verbose_name = "منوی هفتگی"
        verbose_name_plural = "منوهای هفتگی"

    def __str__(self):
        return f"منوی {self.restaurant} - هفته {jdatetime.date.fromgregorian(date=self.week_start_date).strftime('%Y/%m/%d')}"

    def clean(self):
        # هفته باید از شنبه شروع شود
        if self.week_start_date.weekday() != 5:  # شنبه = 5 در jdatetime و Python
            raise ValidationError("تاریخ شروع هفته باید شنبه باشد.")


class MenuItem(models.Model):
    weekly_menu = models.ForeignKey(
        WeeklyMenu, on_delete=models.CASCADE, related_name="items"
    )
    food = models.ForeignKey(
        FoodItem, on_delete=models.CASCADE, verbose_name="غذا", null=True, blank=True
    )
    day_persian = models.CharField(
        max_length=10,
        choices=[
            ("shanbe", "شنبه"),
            ("1shanbe", "یکشنبه"),
            ("2shanbe", "دوشنبه"),
            ("3shanbe", "سه شنبه"),
            ("4shanbe", "چهارشنبه"),
            ("5shanbe", "پنج شنبه"),
            ("jome", "جمعه"),
        ],
        verbose_name="روز هفته",
    )

    class Meta:
        unique_together = ("weekly_menu", "food", "day_persian")
        verbose_name = "غذای منو"
        verbose_name_plural = "غذاهای منو"

    def __str__(self):
        return f"{self.get_day_persian_display()}: {self.food.name}"


class FoodReservation(models.Model):
    PERSIAN_WEEKDAYS = {
        "shanbe": "شنبه",
        "1shanbe": "یکشنبه",
        "2shanbe": "دوشنبه",
        "3shanbe": "سه شنبه",
        "4shanbe": "چهارشنبه",
        "5shanbe": "پنج شنبه",
        "jome": "جمعه",
    }

    RATING_CHOICES = [(i, str(i)) for i in range(1, 6)]

    employee = models.ForeignKey(
        Employee, on_delete=models.CASCADE, related_name="food_reservations"
    )
    menu_item = models.ForeignKey(
        MenuItem, on_delete=models.CASCADE, related_name="reservations"
    )
    reservation_date = models.DateField(verbose_name="تاریخ رزرو", db_index=True)
    reserved_at = models.DateTimeField(auto_now_add=True)
    is_canceled = models.BooleanField(default=False, verbose_name="لغو شده")
    related_factory = models.ForeignKey(
        Factory,
        on_delete=models.SET_NULL,
        verbose_name="کارخانه",
        null=True,
        blank=True,
    )
    rating = models.PositiveSmallIntegerField(
        choices=RATING_CHOICES,
        null=True,
        blank=True,
        verbose_name="امتیاز (۱ تا ۵ ستاره)",
    )
    feedback = models.TextField(
        max_length=500, blank=True, null=True, verbose_name="نظر و پیشنهاد"
    )
    is_delivered = models.BooleanField(default=False, verbose_name="تحویل شده؟")

    factory_quantity = models.PositiveIntegerField(
        default=0, verbose_name="تعداد غذا به قیمت کارخانه"
    )
    free_quantity = models.PositiveIntegerField(
        default=0, verbose_name="تعداد غذا به قیمت آزاد"
    )
    guest_quantity = models.PositiveIntegerField(
        default=0, verbose_name="تعداد غذای مهمان"
    )

    factory_price = models.PositiveIntegerField(default=0, verbose_name="قیمت کارخانه")
    free_price = models.PositiveIntegerField(default=0, verbose_name="قیمت آزاد")
    guest_price = models.PositiveIntegerField(default=0, verbose_name="قیمت غذای مهمان")
    total_price = models.PositiveIntegerField(
        default=0, verbose_name="هزینه کل این سفارش"
    )
    reserved_by = models.PositiveIntegerField(
        default=0, verbose_name="شخص رزرو کننده (اگر خود یوزر بود، میشود 0)"
    )

    def has_feedback(self):
        return bool(self.rating or self.feedback)

    has_feedback.boolean = True
    has_feedback.short_description = "نظر داده شده"

    class Meta:
        verbose_name = "رزرو غذا"
        verbose_name_plural = "رزروهای غذا"
        # 💡 پیشنهاد: ترکیب employee و menu_item و reservation_date را یونیک کنید تا هر کاربر در یک روز فقط یک بار یک نوع غذا را انتخاب کند و تعدادش را در quantity بزند.
        # اما چون شما می‌خواهید کاربر بتواند در رابط کاربری چند بار انتخاب کند (مثلا یک بار با قیمت آزاد، یک بار سهمیه)، اجازه می‌دهیم یونیک نباشد و بعداً ادغام می‌شود.
        # برای سادگی، فعلاً یونیک بودن را برمی‌داریم.

    def __str__(self):
        return f"{self.employee.full_name} - {self.menu_item} ({self.reservation_date})"

    def clean(self):

        today_gdate = date.today()
        # نمی‌توان برای گذشته رزرو کرد
        # if self.reservation_date < today_gdate:
        #     raise ValidationError("نمی‌توانید برای روزهای گذشته رزرو کنید.")

        # امروز فقط تا ساعت 10 صبح
        if self.reservation_date == today_gdate:

            tehran_aware_datetime = timezone.localtime(timezone.now())

        # فقط روزهای منو (شنبه تا پنج‌شنبه یا جمعه اگر منو داشت)
        if self.menu_item.weekly_menu.week_start_date > self.reservation_date:
            raise ValidationError("این غذا برای این تاریخ در منو موجود نیست.")

        # ایا غذا برای همین روز هفته است یا تفاوت دارد؟>
        j_res_date = jdate.fromgregorian(date=self.reservation_date)

        # نگاشت روزهای هفته jdatetime به مقادیر day_persian در MenuItem
        weekday_map = {
            0: "shanbe",  # شنبه
            1: "1shanbe",  # یکشنبه
            2: "2shanbe",  # دوشنبه
            3: "3shanbe",  # سه‌شنبه
            4: "4shanbe",  # چهارشنبه
            5: "5shanbe",  # پنج‌شنبه
            6: "jome",  # جمعه
        }

        # expected_day = weekday_map[j_res_date.weekday()]
        expected_day_en = weekday_map[j_res_date.weekday()]
        expected_day_fa = self.PERSIAN_WEEKDAYS.get(expected_day_en, expected_day_en)

        if self.menu_item.day_persian != expected_day_en:

            raise ValidationError(
                f"غذای '{self.menu_item.food.name}' برای روز {self.menu_item.get_day_persian_display()} "
                f"تعریف شده است، اما شما برای روز {expected_day_fa} می خواهید رزرو کنید."
            )

    def save(self, *args, **kwargs):
        # اگر فقط rating و feedback آپدیت میشه، اعتبارسنجی کامل نزن
        if kwargs.get("update_fields") and {"rating", "feedback"}.issubset(
            set(kwargs["update_fields"])
        ):
            super().save(*args, **kwargs)
            return

        # else:
        #     self.full_clean()  # فقط وقتی رزرو جدید یا ویرایش مهمه
        #     super().save(*args, **kwargs)

        with transaction.atomic():
            # 1. تعیین رزروکننده و گیرنده
            receiver = self.employee
            # if self.reserved_by == 0 or self.reserved_by == receiver.id:
            if self.reserved_by == 0:
                # رزرو برای خود
                reserver = receiver
                is_self = True
            else:
                # رزرو برای دیگران
                reserver = Employee.objects.select_for_update().get(id=self.reserved_by)
                is_self = False
                if reserver.can_reserve_for_others == 0:
                    raise ValidationError("شما مجاز به رزرو برای دیگران نیستید.")

            # 2. قفل روی رزروهای موجود گیرنده (برای همان روز)
            receiver_reservations = FoodReservation.objects.select_for_update().filter(
                employee=receiver,
                reservation_date=self.reservation_date,
                is_canceled=False,
            )
            # اگر در حال ویرایش هستیم، خود این رکورد را از جمع‌آوری خارج می‌کنیم
            if self.pk:
                receiver_reservations = receiver_reservations.exclude(pk=self.pk)

            # 3. اگر رزرو برای دیگران است، قفل روی رزروهای قبلی رزروکننده (برای دیگران)
            reserver_others_reservations = None
            if not is_self:
                reserver_others_reservations = (
                    FoodReservation.objects.select_for_update().filter(
                        reserved_by=reserver.id,
                        reservation_date=self.reservation_date,
                        is_canceled=False,
                    )
                )
                if self.pk and self.reserved_by == reserver.id:
                    reserver_others_reservations = reserver_others_reservations.exclude(
                        pk=self.pk
                    )

            # 4. محاسبه میزان استفاده فعلی
            receiver_current = {
                "factory": sum(r.factory_quantity for r in receiver_reservations),
                "free": sum(r.free_quantity for r in receiver_reservations),
                "guest": sum(r.guest_quantity for r in receiver_reservations),
            }
            reserver_others_current = None

            if not is_self:
                reserver_others_current = {
                    "factory": sum(
                        r.factory_quantity for r in reserver_others_reservations
                    ),
                    "free": sum(r.free_quantity for r in reserver_others_reservations),
                    "guest": sum(
                        r.guest_quantity for r in reserver_others_reservations
                    ),
                }

            new_factory = self.factory_quantity
            new_free = self.free_quantity
            new_guest = self.guest_quantity

            # 5. اعمال محدودیت‌ها
            errors = []
            day_name = self.PERSIAN_WEEKDAYS.get(
                self.menu_item.day_persian, self.menu_item.day_persian
            )

            if is_self:
                factory = (
                    self.related_factory
                    or self.menu_item.weekly_menu.restaurant.department.factory
                )

                close_hour = factory.close_food_res_time_H
                close_minute = factory.close_food_res_time_M
                now = timezone.localtime(timezone.now()).time()
                close_time = time(close_hour, close_minute)

                # اگر تاریخ رزرو امروز است و ساعت فعلی از مهلت گذشته باشد
                if self.reservation_date == timezone.now().date() and now > close_time:
                    raise ValidationError(
                        f"مهلت رزرو غذا برای امروز تا ساعت {close_hour:02d}:{close_minute:02d} است. "
                        "امکان ثبت رزرو جدید وجود ندارد."
                    )

                # محدودیت‌های شخص رزروکننده (که همان گیرنده است)
                limits = {
                    "factory": reserver.factory_limit_reservation,
                    "free": reserver.free_limit_reservation,
                    "guest": reserver.guest_limit_reservation,
                }
                if receiver_current["factory"] + new_factory > limits["factory"]:
                    remaining = limits["factory"] - receiver_current["factory"]
                    errors.append(
                        f"سهمیه‌ای: حداکثر {limits['factory']} عدد، باقی مانده {remaining} عدد"
                    )
                if receiver_current["free"] + new_free > limits["free"]:
                    remaining = limits["free"] - receiver_current["free"]
                    errors.append(
                        f"آزاد: حداکثر {limits['free']} عدد، باقی مانده {remaining} عدد"
                    )
                if receiver_current["guest"] + new_guest > limits["guest"]:
                    remaining = limits["guest"] - receiver_current["guest"]
                    errors.append(
                        f"مهمان: حداکثر {limits['guest']} عدد، باقی مانده {remaining} عدد"
                    )
                if errors:
                    detailed_errors = " • ".join(errors)
                    raise ValidationError(
                        f"برای روز {day_name} نمی توانید بیشتر از حد مجاز رزرو کنید: \n {detailed_errors}"
                    )

            else:
                # الف) محدودیت‌های کلی رزروکننده برای دیگران
                reserver_limits = {
                    "factory": reserver.factory_limit_reservation_for_others,
                    "free": reserver.free_limit_reservation_for_others,
                    "guest": reserver.guest_limit_reservation_for_others,
                }
                if (
                    reserver_others_current["factory"] + new_factory
                    > reserver_limits["factory"]
                ):
                    remaining = (
                        reserver_limits["factory"] - reserver_others_current["factory"]
                    )
                    errors.append(
                        f"محدودیت رزرو سهمیه ای (برای دیگران): حداکثر {reserver_limits['factory']} عدد، باقی مانده این محدودیت {remaining} عدد"
                    )
                if reserver_others_current["free"] + new_free > reserver_limits["free"]:
                    remaining = (
                        reserver_limits["free"] - reserver_others_current["free"]
                    )
                    errors.append(
                        f"محدودیت رزرو آزاد (برای دیگران): حداکثر {reserver_limits['free']} عدد، باقی مانده این محدودیت {remaining} عدد"
                    )
                if (
                    reserver_others_current["guest"] + new_guest
                    > reserver_limits["guest"]
                ):
                    remaining = (
                        reserver_limits["guest"] - reserver_others_current["guest"]
                    )
                    errors.append(
                        f"محدودیت رزرو مهمان (برای دیگران): حداکثر {reserver_limits['guest']} عدد، باقی مانده این محدودیت {remaining} عدد"
                    )

                # ب) در صورت can_reserve_for_others == 1 ، محدودیت‌های شخصی گیرنده نیز اعمال شود
                if reserver.can_reserve_for_others == 1:
                    receiver_limits = {
                        "factory": receiver.factory_limit_reservation,
                        "free": receiver.free_limit_reservation,
                        "guest": receiver.guest_limit_reservation,
                    }
                    if (
                        receiver_current["factory"] + new_factory
                        > receiver_limits["factory"]
                    ):
                        remaining = (
                            receiver_limits["factory"] - receiver_current["factory"]
                        )
                        errors.append(
                            f"محدودیت رزرو سهمیه ای گیرنده: حداکثر {receiver_limits['factory']} عدد، باقی مانده این محدودیت {remaining} عدد"
                        )
                    if receiver_current["free"] + new_free > receiver_limits["free"]:
                        remaining = receiver_limits["free"] - receiver_current["free"]
                        errors.append(
                            f"محدودیت رزرو آزاد گیرنده: حداکثر {receiver_limits['free']} عدد، باقی مانده این محدودیت {remaining} عدد"
                        )
                    if receiver_current["guest"] + new_guest > receiver_limits["guest"]:
                        remaining = receiver_limits["guest"] - receiver_current["guest"]
                        errors.append(
                            f"محدودیت رزرو مهمان گیرنده: حداکثر {receiver_limits['guest']} عدد، باقی مانده این محدودیت {remaining} عدد"
                        )

                if errors:
                    detailed_errors = " • ".join(errors)
                    raise ValidationError(
                        f"برای روز {day_name} محدودیت های رزرو برای دیگران \n (کاربر دریافت کننده: {receiver.full_name}): \n {detailed_errors}"
                    )

            # 6. در صورت عدم خطا، رزرو را ذخیره می‌کنیم
            super().save(*args, **kwargs)


class OrgUnit(models.Model):
    UNIT_TYPE_CHOICES = (
        ("holding", "هلدینگ"),
        ("factory", "کارخانه"),
        ("department", "بخش"),
        ("subdepartment", "زیربخش"),
    )

    unit_type = models.CharField(max_length=20, choices=UNIT_TYPE_CHOICES)

    holding = models.ForeignKey(
        Holding, null=True, blank=True, on_delete=models.CASCADE
    )
    factory = models.ForeignKey(
        Factory, null=True, blank=True, on_delete=models.CASCADE
    )
    department = models.ForeignKey(
        Department, null=True, blank=True, on_delete=models.CASCADE
    )
    subdepartment = models.ForeignKey(
        Subdepartment, null=True, blank=True, on_delete=models.CASCADE
    )

    # ✅ کلید یکتای امن برای MariaDB (بدون مشکل NULL)
    path_key = models.CharField(max_length=100, unique=True, db_index=True)

    def save(self, *args, **kwargs):
        self.path_key = (
            f"{self.unit_type}-"
            f"{self.holding_id or 0}-"
            f"{self.factory_id or 0}-"
            f"{self.department_id or 0}-"
            f"{self.subdepartment_id or 0}"
        )
        super().save(*args, **kwargs)

    # def __str__(self):
    #     return self.path_key

    def get_display_name(self):
        """نام خوانا برای نمایش در فرانت‌اند"""
        if self.unit_type == "holding" and self.holding:
            return f"هلدینگ: {self.holding.name}"
        elif self.unit_type == "factory" and self.factory:
            return f"کارخانه: {self.factory.name}"
        elif self.unit_type == "department" and self.department:
            return f"بخش: {self.department.name}"
        elif self.unit_type == "subdepartment" and self.subdepartment:
            return f"زیربخش: {self.subdepartment.name}"
        elif self.unit_type == "system":
            return "مدیر کل (سیستم)"
        return self.path_key  # fallback

    def get_unit_name(self):
        """فقط نام واحد بدون پیشوند"""
        if self.holding:
            return self.holding.name
        elif self.factory:
            return self.factory.name
        elif self.department:
            return self.department.name
        elif self.subdepartment:
            return self.subdepartment.name
        return "نامشخص"

    def __str__(self):
        return self.get_display_name()


class Referral(models.Model):
    title = models.CharField(max_length=200, verbose_name="عنوان")
    description = models.TextField(verbose_name="توضیحات")

    participation = models.ForeignKey(
        Participation, on_delete=models.CASCADE, related_name="referrals"
    )

    # ✅ هویت سازمانی ارسال‌کننده
    created_by_unit = models.ForeignKey(
        OrgUnit, on_delete=models.PROTECT, related_name="created_referrals"
    )

    # ✅ نقش ارسال‌کننده
    created_by_role = models.ForeignKey(Role, on_delete=models.PROTECT)

    # ✅ خود فرد (چون یوزر پاک نمی‌شود)
    created_by_user = models.ForeignKey(
        Employee, on_delete=models.PROTECT, related_name="created_referrals"
    )

    # ✅ مقصد نهایی ارجاع (واقعی و سازمانی)
    final_unit = models.ForeignKey(
        OrgUnit, on_delete=models.PROTECT, related_name="final_referrals"
    )

    created_at = models.DateTimeField(auto_now_add=True)
    is_closed = models.BooleanField(default=False)

    def __str__(self):
        return f"Referral #{self.id}"


class ReferralStep(models.Model):
    referral = models.ForeignKey(
        Referral, on_delete=models.CASCADE, related_name="steps"
    )

    # ✅ هویت سازمانی فرستنده و گیرنده در این مرحله
    from_unit = models.ForeignKey(
        OrgUnit, on_delete=models.PROTECT, related_name="sent_steps"
    )

    to_unit = models.ForeignKey(
        OrgUnit, on_delete=models.PROTECT, related_name="received_steps"
    )

    # ✅ نقش‌ها در این مرحله
    from_role = models.ForeignKey(
        Role, on_delete=models.PROTECT, related_name="sent_steps"
    )

    to_role = models.ForeignKey(
        Role, on_delete=models.PROTECT, related_name="received_steps"
    )

    # ✅ یوزر واقعی (چون حذف نمی‌شود)
    from_user = models.ForeignKey(
        Employee, on_delete=models.PROTECT, related_name="sent_referral_steps"
    )

    to_user = models.ForeignKey(
        Employee, on_delete=models.PROTECT, related_name="received_referral_steps"
    )

    # ✅ کامنت این مرحله
    comment = models.TextField()

    created_at = models.DateTimeField(auto_now_add=True)

    # ✅ وضعیت این مرحله
    is_approved = models.BooleanField(null=True)  # None = در انتظار

    # ✅ ترتیب دقیق رسیدن ارجاع
    order = models.PositiveIntegerField()

    class Meta:
        ordering = ["order"]
        unique_together = ("referral", "order")

    def __str__(self):
        return f"Step {self.order} of Referral #{self.referral_id}"


class Notification(models.Model):

    title = models.CharField(max_length=200, verbose_name="عنوان اعلان")
    description = models.TextField(verbose_name="توضیحات اعلان")
    created_by = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name="created_notifications",
        verbose_name="ایجادکننده",
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ایجاد")
    expires_at = models.DateTimeField(
        null=True, blank=True, verbose_name="تاریخ انقضا (اختیاری)"
    )
    is_active = models.BooleanField(default=True, verbose_name="فعال")

    # هدف‌گذاری نقش‌ها (لیست نقش‌هایی که اعلان برایشان نمایش داده شود)
    target_roles = models.ManyToManyField(
        Role,
        null=True,
        blank=True,
        related_name="targeted_notifications",
        verbose_name="نقش‌های هدف (چه کسانی ببینند)",
    )

    # هدف‌گذاری واحدها (اختیاری، برای محدود کردن به سطوح خاص)
    # نکته: در فرم، فقط واحدها/نقش‌های مجاز بر اساس نقش created_by نمایش داده شود.
    # مثلاً مدیر کارخانه نمی‌تواند هلدینگ انتخاب کند، فقط کارخانه خودش و زیرمجموعه‌هایش.
    target_holdings = models.ManyToManyField(
        Holding,
        null=True,
        blank=True,
        related_name="targeted_notifications",
        verbose_name="هلدینگ‌های هدف (فقط هلدینگ‌های مجاز)",
    )
    target_factories = models.ManyToManyField(
        Factory,
        null=True,
        blank=True,
        related_name="targeted_notifications",
        verbose_name="کارخانه‌های هدف (از هلدینگ‌های انتخابی)",
    )
    target_departments = models.ManyToManyField(
        Department,
        blank=True,
        related_name="targeted_notifications",
        verbose_name="بخش‌های هدف (از کارخانه‌های انتخابی)",
    )
    target_subdepartments = models.ManyToManyField(
        Subdepartment,
        blank=True,
        related_name="targeted_notifications",
        verbose_name="زیربخش‌های هدف (از بخش‌های انتخابی)",
    )

    # فیلد اضافی برای هدف‌گذاری پرسنل: لیست زیربخش‌هایی که پرسنل‌شان (با نقش employee) ببینند
    # این فیلد جداگانه است تا تمایز بین سطوح مدیریتی و پرسنلی حفظ شود، بر اساس پیشنهاد شما.
    employee_subdepartments = models.ManyToManyField(
        Subdepartment,
        blank=True,
        related_name="employee_targeted_notifications",
        verbose_name="زیربخش‌های پرسنل (پرسنل کدام زیربخش‌ها ببینند - فقط نقش employee)",
    )

    class Meta:
        verbose_name = "اعلان"
        verbose_name_plural = "اعلانات"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} (ایجاد توسط {self.created_by.full_name})"

    def clean(self):

        if self.pk is None:
            return
        # اعتبارسنجی پایه: مثلاً اگر target_holdings انتخاب شده، target_factories باید از آن هلدینگ‌ها باشد
        # (این را می‌توان در فرم هم چک کرد، اما اینجا برای ایمنی مدل)
        if self.target_factories.exists():
            for factory in self.target_factories.all():
                if not self.target_holdings.filter(id=factory.holding_id).exists():
                    raise models.ValidationError(
                        "کارخانه‌های انتخابی باید زیر هلدینگ‌های هدف باشند."
                    )

        if self.target_departments.exists():
            for dept in self.target_departments.all():
                if not self.target_factories.filter(id=dept.factory_id).exists():
                    raise models.ValidationError(
                        "بخش‌های انتخابی باید زیر کارخانه‌های هدف باشند."
                    )

        if self.target_subdepartments.exists():
            for subdept in self.target_subdepartments.all():
                if not self.target_departments.filter(
                    id=subdept.department_id
                ).exists():
                    raise models.ValidationError(
                        "زیربخش‌های انتخابی باید زیر بخش‌های هدف باشند."
                    )

        if self.employee_subdepartments.exists():
            for emp_subdept in self.employee_subdepartments.all():
                if not self.target_subdepartments.filter(id=emp_subdept.id).exists():
                    raise models.ValidationError(
                        "زیربخش‌های پرسنل باید از زیربخش‌های هدف انتخاب شوند."
                    )
                # همچنین: فقط اگر 'employee' در target_roles باشد
                if not self.target_roles.filter(name="employee").exists():
                    raise models.ValidationError(
                        "برای انتخاب زیربخش‌های پرسنل، نقش 'employee' باید در نقش‌های هدف باشد."
                    )

    def save(self, *args, **kwargs):
        self.full_clean()  # اجرای اعتبارسنجی قبل از ذخیره
        super().save(*args, **kwargs)

    def is_visible_to(self, employee: Employee) -> bool:
        """
        متد کمکی برای چک اینکه آیا این اعلان برای یک کاربر خاص قابل نمایش است.
        (این را در view/query استفاده کنید)
        """
        if not self.is_active or (self.expires_at and self.expires_at < timezone.now()):
            return False

        # چک نقش: باید نقش کاربر در target_roles باشد
        user_roles = employee.roles.all()
        if not self.target_roles.filter(
            id__in=user_roles.values_list("id", flat=True)
        ).exists():
            return False

        # چک واحد: کاربر باید در یکی از واحدهای هدف باشد
        # (بر اساس assignment یا مدیریت - این را بر اساس ساختار شما سفارشی کنید)
        # مثال ساده:
        if self.target_holdings.exists() and employee.managed_holdings.exists():
            if employee.managed_holdings.filter(
                id__in=self.target_holdings.all()
            ).exists():
                return True

        if self.target_factories.exists() and employee.managed_factories.exists():
            if employee.managed_factories.filter(
                id__in=self.target_factories.all()
            ).exists():
                return True

        if self.target_departments.exists() and employee.managed_departments.exists():
            if employee.managed_departments.filter(
                id__in=self.target_departments.all()
            ).exists():
                return True

        # برای پرسنل (employee): چک assigned_subdepartments
        if "employee" in user_roles.values_list("name", flat=True):
            if (
                self.employee_subdepartments.exists()
                and employee.assigned_subdepartments.filter(
                    id__in=self.employee_subdepartments.all()
                ).exists()
            ):
                return True

        # اگر هیچ محدودیتی نباشد، یا کاربر super_admin باشد، نمایش بده
        if not any(
            [
                self.target_holdings.exists(),
                self.target_factories.exists(),
                self.target_departments.exists(),
                self.target_subdepartments.exists(),
                self.employee_subdepartments.exists(),
            ]
        ):
            return True

        return False


class NotificationRead(models.Model):
    notification = models.ForeignKey(
        Notification, on_delete=models.CASCADE, related_name="reads"
    )
    employee = models.ForeignKey(
        Employee, on_delete=models.CASCADE, related_name="read_notifications"
    )
    read_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ("notification", "employee")
        verbose_name = "خواندن اعلان"
        verbose_name_plural = "خواندن اعلانات"


class Gender(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد جنسیت")
    title = models.CharField(max_length=20, unique=True, verbose_name="عنوان")

    class Meta:
        verbose_name = "جنسیت"
        verbose_name_plural = "جنسیت‌ها"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.title}"


class RelativeType(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد نسبت")
    name = models.CharField(max_length=50, unique=True, verbose_name="نام نسبت")

    class Meta:
        verbose_name = "نسبت با بیمه‌شده"
        verbose_name_plural = "نسبت‌های خانوادگی"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class DependencyStatus(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد وضعیت")
    name = models.CharField(max_length=50, unique=True, verbose_name="نام وضعیت تکفل")

    class Meta:
        verbose_name = "وضعیت تکفل"
        verbose_name_plural = "وضعیت‌های تکفل"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class MaritalStatus(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد وضعیت")
    name = models.CharField(max_length=50, unique=True, verbose_name="نام وضعیت تاهل")

    class Meta:
        verbose_name = "وضعیت تاهل"
        verbose_name_plural = "وضعیت‌های تاهل"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class EmploymentType(models.Model):
    code = models.PositiveSmallIntegerField(
        primary_key=True, verbose_name="کد نوع استخدام"
    )
    name = models.CharField(max_length=50, unique=True, verbose_name="نام نوع استخدام")

    class Meta:
        verbose_name = "نوع استخدام"
        verbose_name_plural = "انواع استخدام"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class JobGroup(models.Model):
    code = models.PositiveSmallIntegerField(
        primary_key=True, verbose_name="کد گروه شغلی"
    )
    name = models.CharField(max_length=100, unique=True, verbose_name="عنوان گروه شغلی")

    class Meta:
        verbose_name = "گروه شغلی"
        verbose_name_plural = "گروه‌های شغلی"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.title}"


class BaseInsurance(models.Model):
    code = models.PositiveSmallIntegerField(
        primary_key=True, verbose_name="کد بیمه گر پایه"
    )
    name = models.CharField(
        max_length=100, unique=True, verbose_name="نام بیمه گر پایه"
    )

    class Meta:
        verbose_name = "بیمه گر پایه"
        verbose_name_plural = "بیمه گران پایه"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class PreviousInsurer(models.Model):
    code = models.PositiveSmallIntegerField(
        primary_key=True, verbose_name="کد بیمه گر قبلی"
    )
    name = models.CharField(
        max_length=100, unique=True, verbose_name="نام بیمه گر قبلی"
    )

    class Meta:
        verbose_name = "بیمه گر قبلی"
        verbose_name_plural = "بیمه گران قبلی"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class Country(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد کشور")
    name = models.CharField(max_length=100, unique=True, verbose_name="نام کشور")

    class Meta:
        verbose_name = "کشور"
        verbose_name_plural = "کشورها"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class Banks(models.Model):
    code = models.PositiveSmallIntegerField(primary_key=True, verbose_name="کد بانک")
    name = models.CharField(max_length=100, unique=True, verbose_name="نام بانک")

    class Meta:
        verbose_name = "بانک"
        verbose_name_plural = "بانک ها"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class ContactInfo(models.Model):
    # فقط یکی از این دو فیلد پر می‌شه، دیگری None می‌مونه
    employee = models.ForeignKey(
        "Employee",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="contact_infos",
        verbose_name="کارمند",
    )
    dependent = models.ForeignKey(
        "Dependent",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="contact_infos",
        verbose_name="وابسته",
    )

    phone_number = models.CharField(max_length=11, verbose_name="شماره تلفن")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ افزودن")

    class Meta:
        verbose_name = "شماره تماس"
        verbose_name_plural = "شماره‌های تماس"
        ordering = ["-created_at"]
        constraints = [
            models.CheckConstraint(
                check=(
                    (
                        models.Q(employee__isnull=False)
                        & models.Q(dependent__isnull=True)
                    )
                    | (
                        models.Q(employee__isnull=True)
                        & models.Q(dependent__isnull=False)
                    )
                ),
                name="contactinfo_one_owner_only",
            )
        ]

    def __str__(self):
        if self.employee:
            owner = self.employee.full_name
        elif self.dependent:
            owner = f"{self.dependent.first_name} {self.dependent.last_name}"
        else:
            owner = "نامشخص"
        return f"{self.phone_number} - {owner}"

    def clean(self):
        if (self.employee and self.dependent) or (
            not self.employee and not self.dependent
        ):
            raise ValidationError(
                "شماره تماس باید دقیقاً به یک نفر (کارمند یا وابسته) تعلق داشته باشد."
            )

        if self.phone_number:
            if (
                not self.phone_number.isdigit()
                or len(self.phone_number) != 11
                or not self.phone_number.startswith("09")
            ):
                raise ValidationError("شماره تلفن باید ۱۱ رقمی و با ۰۹ شروع شود.")


class BankAccountType(models.Model):
    code = models.PositiveSmallIntegerField(
        primary_key=True, verbose_name="کد نوع حساب"
    )
    name = models.CharField(max_length=100, unique=True, verbose_name="نوع حساب بانکی")

    class Meta:
        verbose_name = "نوع حساب بانکی"
        verbose_name_plural = "نوع حساب های بانکی"
        ordering = ["code"]

    def __str__(self):
        return f"{self.code} - {self.name}"


class BankAccount(models.Model):
    # فقط یکی از این دو فیلد پر میشه، دیگری None می‌مونه
    employee = models.ForeignKey(
        "Employee",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="bank_accounts",
        verbose_name="کارمند",
    )
    dependent = models.ForeignKey(
        "Dependent",
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        related_name="bank_accounts",
        verbose_name="وابسته",
    )
    bank = models.ForeignKey(
        Banks, blank=True, null=True, on_delete=models.PROTECT, verbose_name="بانک"
    )
    bank_account_type = models.ForeignKey(
        BankAccountType,
        on_delete=models.PROTECT,
        blank=True,
        null=True,
        verbose_name="نوع حساب بانکی",
    )
    account_number = models.CharField(
        max_length=16, blank=True, null=True, verbose_name="شماره حساب"
    )
    card_number = models.CharField(
        max_length=16, blank=True, null=True, verbose_name="شماره کارت"
    )
    ir = models.CharField(max_length=2, default="ir", editable=False, verbose_name="ir")
    sheba_number = models.CharField(
        max_length=26, blank=True, null=True, verbose_name="شماره شبا"
    )

    class Meta:
        verbose_name = "حساب بانکی"
        verbose_name_plural = "حساب‌های بانکی"
        constraints = [
            models.CheckConstraint(
                check=(
                    (
                        models.Q(employee__isnull=False)
                        & models.Q(dependent__isnull=True)
                    )
                    | (
                        models.Q(employee__isnull=True)
                        & models.Q(dependent__isnull=False)
                    )
                ),
                name="bankaccount_one_owner_only",
            )
        ]

    def __str__(self):
        owner = (
            self.employee.full_name if self.employee else self.dependent.get_full_name()
        )
        return f"{self.bank.name} - {self.sheba_number} ({owner})"

    def clean(self):
        if (self.employee and self.dependent) or (
            not self.employee and not self.dependent
        ):
            raise ValidationError(
                "حساب بانکی باید دقیقاً به یک نفر (کارمند یا وابسته) تعلق داشته باشد."
            )

    def get_full_name(self):
        return f"{self.first_name} {self.last_name}"


class Dependent(models.Model):
    employee = models.ForeignKey(
        "Employee",
        on_delete=models.CASCADE,
        related_name="dependents",
        verbose_name="کارمند اصلی",
    )
    relative_type = models.ForeignKey(
        "RelativeType", on_delete=models.PROTECT, verbose_name="نسبت"
    )
    national_id = models.CharField(max_length=10, unique=True, verbose_name="کد ملی")
    first_name = models.CharField(max_length=50, verbose_name="نام")
    last_name = models.CharField(max_length=50, verbose_name="نام خانوادگی")
    father_name = models.CharField(
        max_length=50, null=True, blank=True, verbose_name="نام پدر"
    )
    birth_certificate_number = models.CharField(
        max_length=50, null=True, blank=True, verbose_name="شماره شناسنامه"
    )
    birth_date = models.DateField(null=True, blank=True, verbose_name="تاریخ تولد")
    marital_status = models.ForeignKey(
        "MaritalStatus",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        verbose_name="وضعیت تأهل",
    )
    dependency_status = models.ForeignKey(
        "DependencyStatus",
        null=True,
        blank=True,
        on_delete=models.PROTECT,
        verbose_name="وضعیت تکفل",
    )
    gender = models.ForeignKey(
        "Gender", on_delete=models.PROTECT, null=True, blank=True, verbose_name="جنسیت"
    )
    country = models.ForeignKey(
        "Country", on_delete=models.PROTECT, null=True, blank=True, verbose_name="کشور"
    )

    class Meta:
        verbose_name = "وابسته"
        verbose_name_plural = "وابستگان"
        unique_together = (
            "employee",
            "national_id",
        )  # یک نفر نمی‌تونه دو بار وابسته یک کارمند باشه

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.relative_type}) - وابسته {self.employee.full_name}"


class Employee_Bimeh(models.Model):
    employee = models.ForeignKey(
        "Employee",
        on_delete=models.CASCADE,
        related_name="bimeh",
        verbose_name="کارمند اصلی",
    )
    bimeh_nubmer = models.CharField(
        max_length=50, null=True, blank=True, verbose_name="شماره بیمه"
    )
    employment_date = models.DateField(
        null=True, blank=True, verbose_name="تاریخ استخدام"
    )
    employment_type = models.ForeignKey(
        "EmploymentType",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        verbose_name="نوع استخدام",
    )
    job_group = models.ForeignKey(
        "JobGroup",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        verbose_name="گروه شغلی",
    )
    base_insurance = models.ForeignKey(
        "BaseInsurance",
        on_delete=models.PROTECT,
        null=True,
        blank=True,
        verbose_name="بیمه گر پایه",
    )
    country = models.ForeignKey(
        "Country", on_delete=models.PROTECT, null=True, blank=True, verbose_name="کشور"
    )
    previous_insurer = models.ForeignKey(
        "PreviousInsurer",
        on_delete=models.PROTECT,
        blank=True,
        null=True,
        verbose_name="بیمه گر قبلی",
    )
    coverage_duration = models.PositiveIntegerField(
        blank=True, null=True, verbose_name="مدت پوشش (ماه)"
    )
