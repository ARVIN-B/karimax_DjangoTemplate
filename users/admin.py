from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from django.contrib.auth.forms import UserChangeForm
from django.contrib.admin.widgets import FilteredSelectMultiple
from django import forms
from django.utils.html import format_html
from .models import (
    Employee,
    Factory,
    Department,
    Role,
    PermissionLevel,
    Evaluation,
    Participation,
    Holding,
    Subdepartment,
)

from django.utils.translation import gettext_lazy as _
from django.forms import NumberInput
from django.db import models
from django.db.models import Count


class RoleFilter(admin.SimpleListFilter):
    title = "نقش"
    parameter_name = "role"

    def lookups(self, request, model_admin):
        roles = Role.objects.all().values_list("name", flat=True).distinct()
        return [
            (name, name)
            for name in [
                "employee",
                "supervisor",
                "department_manager",
                "factory_manager",
                "holding_manager",
                "super_admin",
            ]
            if name in roles
        ]

    def queryset(self, request, queryset):
        if self.value():
            return queryset.filter(user__roles__name=self.value())
        return queryset


@admin.register(Holding)
class HoldingAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "location",
        # "manager",
        # "managers",
        "created_at",
        "factory_count",
    ]
    search_fields = ["name", "location"]
    list_filter = ["created_at"]
    readonly_fields = ["created_at"]
    fieldsets = (
        (
            _("اطلاعات اصلی"),
            {
                "fields": (
                    "name",
                    "location",
                    "managers",
                    "manager",
                )
            },
        ),
        (
            _("اطلاعات سیستمی"),
            {
                "fields": ("created_at",),
                "classes": ("collapse",),
            },
        ),
    )

    def factory_count(self, obj):
        return obj.factories.count()

    factory_count.short_description = "تعداد کارخانه‌ها"


@admin.register(Factory)
class FactoryAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "location",
        "holding",
        # "managers",
        # "manager",
        "created_at",
        "department_count",
        "employee_count",
        "reservation_close_time_display",  # ← ستون جدید برای نمایش خوانا
        "is_committee",
    ]

    list_filter = ["holding", "is_committee", "created_at"]

    search_fields = ["name", "location", "holding__name"]

    readonly_fields = ["created_at"]

    # گروه‌بندی فیلدها در فرم ادمین
    fieldsets = (
        (
            _("اطلاعات اصلی"),
            {
                "fields": (
                    "name",
                    "location",
                    "holding",
                    "managers",
                    "manager",
                )
            },
        ),
        (
            _("تنظیمات مرتبط با کمیته ها"),
            {
                "fields": (
                    "is_committee",
                    "linked_factory",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            _("زمان بسته شدن رزرو غذا"),
            {
                "fields": ("close_food_res_time_H", "close_food_res_time_M"),
                "description": _(
                    """
                        ساعت و دقیقه‌ای که رزرو غذا برای این کارخانه بسته می‌شود.
                        <br>• ساعت: ۰ تا ۲۳
                        <br>• دقیقه: ۰ تا ۵۹
                    """
                ),
                "classes": ("collapse",),
            },
        ),
        (
            _("اطلاعات سیستمی"),
            {
                "fields": ("created_at",),
                "classes": ("collapse",),
            },
        ),
    )

    # برای نمایش بهتر در لیست
    def reservation_close_time_display(self, obj):
        h = obj.close_food_res_time_H
        m = obj.close_food_res_time_M
        return f"{h:02d}:{m:02d}"

    reservation_close_time_display.short_description = "ساعت بسته شدن رزرو"
    reservation_close_time_display.admin_order_field = "close_food_res_time_H"

    formfield_overrides = {
        models.IntegerField: {
            "widget": NumberInput(
                attrs={
                    "min": 0,
                    # "max": 23 if "close_food_res_time_H" else 59,
                    "style": "width: 80px;",
                }
            )
        },
    }

    def formfield_for_dbfield(self, db_field, request, **kwargs):
        field = super().formfield_for_dbfield(db_field, request, **kwargs)
        if db_field.name in ("close_food_res_time_H", "close_food_res_time_M"):
            max_val = 23 if db_field.name.endswith("_H") else 59
            field.widget.attrs["max"] = str(max_val)
        return field

    # تعداد بخش‌ها
    def department_count(self, obj):
        return obj.departments.count()

    department_count.short_description = "تعداد بخش‌ها"

    # تعداد کل کارمندان (بهبود یافته)
    def employee_count(self, obj):
        # روش بهینه‌تر با QuerySet

        total = (
            obj.departments.aggregate(
                total_employees=Count("subdepartments__assigned_employees")
            )["total_employees"]
            or 0
        )
        return total

    employee_count.short_description = "تعداد کارمندان"


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "factory",
        "holding_name",
        "factory_location",
        # "managers",
        # "manager",
        "created_at",
        "subdepartment_count",
        "is_committee",
        "employee_count",
    ]
    list_filter = ["factory__holding", "factory", "created_at", "is_committee"]
    search_fields = ["name", "factory__name", "factory__holding__name"]
    readonly_fields = ["created_at"]

    fieldsets = (
        (
            _("اطلاعات اصلی"),
            {
                "fields": (
                    "name",
                    "factory",
                    "managers",
                    "manager",
                )
            },
        ),
        (
            _("تنظیمات مرتبط با کمیته ها"),
            {
                "fields": (
                    "is_committee",
                    "manager_2",
                    "manager_3",
                    "linked_factory",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            _("تنظیمات مرتبط با رستوران و سلف"),
            {
                "fields": ("is_self",),
                "classes": ("collapse",),
            },
        ),
        (
            _("اطلاعات سیستمی"),
            {
                "fields": ("created_at",),
                "classes": ("collapse",),
            },
        ),
    )

    # --- نمایش نام هلدینگ ---
    def holding_name(self, obj):
        return obj.factory.holding.name if obj.factory and obj.factory.holding else "-"

    holding_name.short_description = "هلدینگ"

    # --- نمایش مکان کارخانه ---
    def factory_location(self, obj):
        return obj.factory.location if obj.factory else "-"

    factory_location.short_description = "مکان کارخانه"

    # --- تعداد زیربخش‌ها ---
    def subdepartment_count(self, obj):
        return obj.subdepartments.count()

    subdepartment_count.short_description = "مجموع زیربخش‌ها"

    # --- تعداد کل کارمندان (از تمام زیربخش‌ها) ---
    def employee_count(self, obj):
        total = 0
        for subdept in obj.subdepartments.all():
            total += subdept.assigned_employees.count()
        return total

    employee_count.short_description = "مجموع کارمندان"


class PermissionLevelInline(admin.StackedInline):
    model = PermissionLevel
    extra = 0
    verbose_name_plural = "سطوح دسترسی"


@admin.register(Subdepartment)
class SubdepartmentAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "department",
        "factory_name",
        "holding_name",
        "factory_location",
        # "supervisor",
        "created_at",
        "is_committee",
        "employee_count",
    ]
    list_filter = [
        "department__factory__holding",
        "department__factory",
        "department",
        "is_committee",
        "created_at",
    ]
    search_fields = [
        "name",
        "department__name",
        "department__factory__name",
        "department__factory__holding__name",
    ]
    readonly_fields = ["created_at"]

    fieldsets = (
        (
            _("اطلاعات اصلی"),
            {
                "fields": (
                    "name",
                    "department",
                    "supervisors",
                    "supervisor",
                )
            },
        ),
        (
            _("تنظیمات مرتبط با کمیته ها"),
            {
                "fields": (
                    "is_committee",
                    "linked_factory",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            _("تنظیمات مرتبط با رستوران و سلف"),
            {
                "fields": ("is_restaurant",),
                "classes": ("collapse",),
            },
        ),
        (
            _("اطلاعات سیستمی"),
            {
                "fields": ("created_at",),
                "classes": ("collapse",),
            },
        ),
    )

    def factory_name(self, obj):
        return (
            obj.department.factory.name
            if obj.department and obj.department.factory
            else "-"
        )

    factory_name.short_description = "کارخانه"

    def holding_name(self, obj):
        if obj.department and obj.department.factory and obj.department.factory.holding:
            return obj.department.factory.holding.name
        return "-"

    holding_name.short_description = "هلدینگ"

    def factory_location(self, obj):
        return (
            obj.department.factory.location
            if obj.department and obj.department.factory
            else "-"
        )

    factory_location.short_description = "مکان کارخانه"

    def employee_count(self, obj):
        return obj.assigned_employees.count()

    employee_count.short_description = "مجموع کارمندان"

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        return qs.select_related(
            "department", "department__factory", "department__factory__holding"
        ).prefetch_related("assigned_employees")


@admin.register(Role)
class RoleAdmin(admin.ModelAdmin):
    list_display = ["name", "description", "can_manage_users", "can_evaluate"]
    list_filter = ["name"]
    inlines = [PermissionLevelInline]
    readonly_fields = ["permissions"]

    def can_manage_users(self, obj):
        return (
            obj.permission_level.can_manage_users
            if hasattr(obj, "permission_level")
            else False
        )

    can_manage_users.boolean = True

    def can_evaluate(self, obj):
        return (
            obj.permission_level.can_evaluate
            if hasattr(obj, "permission_level")
            else False
        )

    can_evaluate.boolean = True


class PermissionLevelAdmin(admin.ModelAdmin):
    list_display = [
        "role",
        "can_manage_users",
        "can_evaluate",
        "can_access_all_departments",
    ]
    list_filter = ["can_manage_users", "can_evaluate", "can_access_all_departments"]


admin.site.register(PermissionLevel, PermissionLevelAdmin)






class EmployeeManagementAssignmentsForm(UserChangeForm):
    managed_holdings_assignments = forms.ModelMultipleChoiceField(
        queryset=Holding.objects.none(),
        required=False,
        label="هلدینگ‌های مدیریتی (managers)",
        widget=FilteredSelectMultiple("هلدینگ‌ها", is_stacked=False),
    )
    managed_factories_assignments = forms.ModelMultipleChoiceField(
        queryset=Factory.objects.none(),
        required=False,
        label="کارخانه‌های مدیریتی (managers)",
        widget=FilteredSelectMultiple("کارخانه‌ها", is_stacked=False),
    )
    managed_departments_assignments = forms.ModelMultipleChoiceField(
        queryset=Department.objects.none(),
        required=False,
        label="بخش‌های مدیریتی (managers)",
        widget=FilteredSelectMultiple("بخش‌ها", is_stacked=False),
    )
    supervised_subdepartments_assignments = forms.ModelMultipleChoiceField(
        queryset=Subdepartment.objects.none(),
        required=False,
        label="زیربخش‌های سرپرستی (supervisors)",
        widget=FilteredSelectMultiple("زیربخش‌ها", is_stacked=False),
    )

    class Meta(UserChangeForm.Meta):
        model = Employee
        fields = "__all__"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields["managed_holdings_assignments"].queryset = Holding.objects.order_by(
            "name"
        )
        self.fields["managed_factories_assignments"].queryset = (
            Factory.objects.order_by("name")
        )
        self.fields["managed_departments_assignments"].queryset = (
            Department.objects.order_by("name")
        )
        self.fields["supervised_subdepartments_assignments"].queryset = (
            Subdepartment.objects.order_by("name")
        )

        if self.instance and self.instance.pk:
            self.fields["managed_holdings_assignments"].initial = (
                self.instance.managed_holdings_m2m.all()
            )
            self.fields["managed_factories_assignments"].initial = (
                self.instance.managed_factories_m2m.all()
            )
            self.fields["managed_departments_assignments"].initial = (
                self.instance.managed_departments_m2m.all()
            )
            self.fields["supervised_subdepartments_assignments"].initial = (
                self.instance.supervised_subdepartments_m2m.all()
            )

    def _save_management_assignments(self):
        if not self.instance.pk:
            return

        self.instance.managed_holdings_m2m.set(
            self.cleaned_data.get("managed_holdings_assignments")
        )
        self.instance.managed_factories_m2m.set(
            self.cleaned_data.get("managed_factories_assignments")
        )
        self.instance.managed_departments_m2m.set(
            self.cleaned_data.get("managed_departments_assignments")
        )
        self.instance.supervised_subdepartments_m2m.set(
            self.cleaned_data.get("supervised_subdepartments_assignments")
        )

    def save(self, commit=True):
        instance = super().save(commit=commit)
        if commit:
            self._save_management_assignments()
        return instance

    def save_m2m(self):
        super().save_m2m()
        self._save_management_assignments()














@admin.register(Employee)
class EmployeeAdmin(UserAdmin):
    add_form_template = "admin/users/employee_add_form.html"
    form = EmployeeManagementAssignmentsForm
    # --- فرم ویرایش ---
    fieldsets = (
        (None, {"fields": ("national_id", "password")}),
        (
            "اطلاعات شخصی",
            {
                "fields": (
                    "personnel_code",
                    "first_name",
                    "last_name",
                    "email",
                )  # اضافه شد
            },
        ),
        ("اطلاعات تماس", {"fields": ("phone_number",)}),
        (
            "اطلاعات سازمانی",
            {"fields": ("assigned_subdepartments", "roles"), "classes": ("collapse",)},
        ),
        (
            "انتساب‌های مدیریتی جدید",
            {
                "fields": (
                    "managed_holdings_assignments",
                    "managed_factories_assignments",
                    "managed_departments_assignments",
                    "supervised_subdepartments_assignments",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "مدیریت پرسنل",
            {
                "fields": (
                    "manage_sub_employees",
                    "hr_granting_role_limit",
                    "hr_accessible_holdings",
                    "hr_accessible_factories",
                    "hr_accessible_departments",
                    "hr_accessible_subdepartments",
                    "hr_accessible_employees",



                    # "hr_accessible_holdings",


                    # "managed_factories_assignments",
                    # "managed_departments_assignments",
                    # "supervised_subdepartments_assignments",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "مجوزهای مربوط به سلف",
            {
                "fields": (
                    "unlimit_reservation",
                    "can_serve_foods",
                    "can_reserve_management_food",
                    "factory_limit_reservation",
                    "free_limit_reservation",
                    "guest_limit_reservation",
                    "can_reserve_for_others",
                    "can_reserve_for_which_day",
                    "guest_limit_reservation_for_others",
                    "free_limit_reservation_for_others",
                    "factory_limit_reservation_for_others",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "پنل گزارش گیری",
            {
                "fields": (
                    "reporting_permision",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "تحویل‌گیرنده غذا",
            {
                "fields": (
                    "food_receiver_role",
                    "food_receiver_factory",
                    "food_receiver_holding",
                ),
            },
        ),
        (
            "مجوزهای دیگر",
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "is_first_login",
                    "factory_bimeh",
                    "holding_bimeh",
                    "is_contractor",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "تاریخ‌ها",
            {"fields": ("last_login", "date_joined"), "classes": ("collapse",)},
        ),
    )

    # --- فرم ایجاد ---
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "national_id",
                    "personnel_code",
                    "first_name",
                    "last_name",
                    "phone_number",
                    "assigned_subdepartments",
                    "roles",
                    "is_contractor",
                    "unlimit_reservation",
                    "factory_limit_reservation",
                    "free_limit_reservation",
                    "guest_limit_reservation",
                    "can_reserve_for_others",
                    "can_reserve_for_which_day",
                    "guest_limit_reservation_for_others",
                    "free_limit_reservation_for_others",
                    "factory_limit_reservation_for_others",
                    "can_serve_foods",
                    "can_reserve_management_food",
                    "factory_bimeh",
                    "holding_bimeh",
                    "password1",
                    "password2",
                    "is_staff",
                    "is_superuser",
                    "food_receiver_role",
                    "food_receiver_factory",
                    "food_receiver_holding",
                    "manage_sub_employees",
                    "hr_granting_role_limit",
                ),
            },
        ),
    )

    # --- لیست نمایش ---
    list_display = [
        "full_name",
        "personnel_code",  # اضافه شد
        "national_id",
        "can_serve_foods",
        "is_contractor",
        "unlimit_reservation",
        "can_reserve_management_food",
        "factory_bimeh",
        "holding_bimeh",
        "phone_number",
        "assigned_subdepartments_display",
        "roles_display",
        "is_active",
        "is_staff",
        "is_superuser",
        "is_first_login",
        "guest_limit_res_display",
        "free_limit_res_display",
        "factory_limit_res_display",
        "can_reserve_for_others",
        "can_reserve_for_which_day",
        "guest_limit_res_for_others_display",
        "free_limit_res_for_others_display",
        "factory_limit_res_for_others_display",
        "reporting_permision",
        "date_joined",
        "food_receiver_role_display",
        "food_receiver_location",
        "manage_sub_employees",
        "hr_granting_role_limit",
    ]

    # --- جستجو ---
    search_fields = [
        "personnel_code",  # اضافه شد
        "first_name",
        "last_name",
        "national_id",
        "phone_number",
        "email",
    ]

    # --- فیلترها ---
    list_filter = [
        "can_serve_foods",
        "unlimit_reservation",
        "can_reserve_management_food",
        "factory_bimeh",
        "holding_bimeh",
        "roles",
        "assigned_subdepartments__department__factory__holding",
        "assigned_subdepartments__department__factory",
        "assigned_subdepartments__department",
        "assigned_subdepartments",
        "is_contractor",
        "is_active",
        "is_staff",
        "is_superuser",
        "is_first_login",
        "factory_limit_reservation",
        "free_limit_reservation",
        "guest_limit_reservation",
        "can_reserve_for_others",
        "can_reserve_for_which_day",
        "guest_limit_reservation_for_others",
        "free_limit_reservation_for_others",
        "factory_limit_reservation_for_others",
        "reporting_permision",
        "date_joined",
        "food_receiver_role",
        "food_receiver_factory",
        "food_receiver_holding",
        "manage_sub_employees",
        "hr_granting_role_limit",
        # 'personnel_code' رو نمی‌ذاریم چون فیلتر روی CharField معنی نداره (مگر با SimpleListFilter)
    ]
    # ویجت مناسب برای فیلدهای عددی (مثل ساعت رزرو کارخانه)
    formfield_overrides = {
        models.IntegerField: {
            "widget": NumberInput(
                attrs={
                    "min": 0,
                    "style": "width: 120px; text-align: center;",
                }
            )
        },
    }

    def guest_limit_res_display(self, obj):
        return obj.guest_limit_reservation

    guest_limit_res_display.short_description = "محدودیت مهمان"
    guest_limit_res_display.admin_order_field = "guest_limit_reservation"

    def free_limit_res_display(self, obj):
        return obj.free_limit_reservation

    free_limit_res_display.short_description = "محدودیت آزاد"
    free_limit_res_display.admin_order_field = "free_limit_reservation"

    def factory_limit_res_display(self, obj):
        return obj.factory_limit_reservation

    factory_limit_res_display.short_description = "محدودیت سهمیه‌ای"
    factory_limit_res_display.admin_order_field = "factory_limit_reservation"

    def guest_limit_res_for_others_display(self, obj):
        return obj.guest_limit_reservation_for_others

    guest_limit_res_for_others_display.short_description = "محدودیت مهمان برای دیگران"
    guest_limit_res_for_others_display.admin_order_field = (
        "guest_limit_reservation_for_others"
    )

    def free_limit_res_for_others_display(self, obj):
        return obj.free_limit_reservation_for_others

    free_limit_res_for_others_display.short_description = "محدودیت آزاد برای دیگران"
    free_limit_res_for_others_display.admin_order_field = (
        "free_limit_reservation_for_others"
    )

    def factory_limit_res_for_others_display(self, obj):
        return obj.factory_limit_reservation_for_others

    factory_limit_res_for_others_display.short_description = (
        "محدودیت سهمیه‌ای برای دیگران"
    )
    factory_limit_res_for_others_display.admin_order_field = (
        "factory_limit_reservation_for_others"
    )

    ordering = ["personnel_code", "last_name", "first_name"]  # مرتب‌سازی بهتر
    readonly_fields = ["date_joined", "last_login"]

    # --- نمایش کد پرسنلی در لیست ---
    def personnel_code_display(self, obj):
        return obj.personnel_code or "-"

    personnel_code_display.short_description = "کد پرسنلی"

    def roles_display(self, obj):
        pass

    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

    full_name.short_description = "نام کامل"

    def assigned_subdepartments_display(self, obj):
        return ", ".join([sd.name for sd in obj.assigned_subdepartments.all()]) or "-"

    assigned_subdepartments_display.short_description = "زیربخش‌های تخصیص‌یافته (فقط برای نقش کارمند)"

    def food_receiver_role_display(self, obj):
        return dict(obj.FOOD_RECEIVER_CHOICES).get(obj.food_receiver_role, "-")

    food_receiver_role_display.short_description = "نقش تحویل‌گیرنده"

    def food_receiver_location(self, obj):
        if obj.food_receiver_role == 1:
            return obj.food_receiver_factory.name if obj.food_receiver_factory else "-"
        if obj.food_receiver_role == 2:
            return obj.food_receiver_holding.name if obj.food_receiver_holding else "-"
        return "-"

    food_receiver_location.short_description = "محل تحویل‌گیری"

    def save_related(self, request, form, formsets, change):
        super().save_related(request, form, formsets, change)

        obj = form.instance
        if not obj or not obj.pk:
            return

        obj.managed_holdings_m2m.set(
            form.cleaned_data.get("managed_holdings_assignments", [])
        )
        obj.managed_factories_m2m.set(
            form.cleaned_data.get("managed_factories_assignments", [])
        )
        obj.managed_departments_m2m.set(
            form.cleaned_data.get("managed_departments_assignments", [])
        )
        obj.supervised_subdepartments_m2m.set(
            form.cleaned_data.get("supervised_subdepartments_assignments", [])
        )





@admin.register(Participation)
class ParticipationAdmin(admin.ModelAdmin):
    list_display = [
        "id",
        "title",
        "user",
        "item_type",
        "role_name",
        "status",
        "is_finalized",
        "is_committee",
        "created_at",
        "file_size_display",
        "factory_link",
        "department_link",
        "subdepartment_link",
        "holding_link",
    ]
    list_filter = [
        "item_type",
        "status",
        "is_committee",
        "is_finalized",
        "created_at",
        "role_name",
        RoleFilter,
        "factory__holding",
        "factory",
        "department",
        "subdepartment",
    ]
    search_fields = [
        "id",
        "title",
        "description",
        "user__national_id",
        "user__first_name",
        "user__last_name",
        "role_name",
        "text_content",
        "summarized_content",
    ]
    readonly_fields = [
        "created_at",
        "file_size",
        "user",
        "id",
    ]
    fieldsets = (
        (
            "اطلاعات اصلی",
            {
                "fields": (
                    "id",
                    "user",
                    "item_type",
                    "title",
                    "description",
                    "attachment",
                    "status",
                    "feedback",
                    "is_finalized",
                )
            },
        ),
        (
            "محتوا و خلاصه",
            {
                "fields": (
                    "text_content",
                    "orginal_content",
                    "summarized_content",
                    "count_sumerized",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "سطوح سازمانی (اصلی)",
            {
                "fields": (
                    ("holding", "factory"),
                    ("department", "subdepartment"),
                )
            },
        ),
        (
            "کمیته",
            {
                "fields": (
                    "is_committee",
                    ("holding_committee", "factory_committee"),
                    ("department_committee", "subdepartment_committee"),
                ),
                "classes": (
                    ("collapse",)
                    if not any([f for f in ["holding_committee", "factory_committee"]])
                    else ()
                ),
            },
        ),
        (
            "فیدبک‌ها",
            {
                "fields": (
                    "supervisor_feedback",
                    "manager_feedback",
                    "manager_2_feedback",
                    "manager_3_feedback",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "وضعیت‌ها",
            {
                "fields": (
                    "supervisor_status",
                    "manager_status",
                    "manager_2_status",
                    "manager_3_status",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "سایر",
            {
                "fields": ("role_name", "file_size", "created_at"),
                "classes": ("collapse",),
            },
        ),
    )

    # --- نمایش حجم فایل ---
    def file_size_display(self, obj):
        if obj.file_size:
            return f"{obj.file_size / 1024:.2f} KB"
        return "بدون فایل"

    file_size_display.short_description = "حجم فایل"

    # --- لینک‌های سازمانی ---
    def factory_link(self, obj):
        if obj.factory:
            return format_html(
                '<a href="?factory_id={}">{}</a>', obj.factory.id, obj.factory.name
            )
        return "-"

    factory_link.short_description = "کارخانه"

    def department_link(self, obj):
        if obj.department:
            return format_html(
                '<a href="?department_id={}">{}</a>',
                obj.department.id,
                obj.department.name,
            )
        return "-"

    department_link.short_description = "بخش"

    def subdepartment_link(self, obj):
        if obj.subdepartment:
            return format_html(
                '<a href="?subdepartment_id={}">{}</a>',
                obj.subdepartment.id,
                obj.subdepartment.name,
            )
        return "-"

    subdepartment_link.short_description = "زیربخش"

    def holding_link(self, obj):
        if obj.holding:
            return format_html(
                '<a href="?holding_id={}">{}</a>', obj.holding.id, obj.holding.name
            )
        return "-"

    holding_link.short_description = "هلدینگ"

    # --- بهینه‌سازی کوئری ---
    def get_queryset(self, request):
        return (
            super()
            .get_queryset(request)
            .select_related(
                "user",
                "holding",
                "factory",
                "department",
                "subdepartment",
                "holding_committee",
                "factory_committee",
                "department_committee",
                "subdepartment_committee",
            )
        )


# @admin.register(Participation)
# class ParticipationAdmin(admin.ModelAdmin):
#     list_display = ['title', 'user', 'item_type', 'created_at', 'file_size_display']
#     list_filter = ['item_type', 'created_at', RoleFilter]  # حذف user__role__name
#     search_fields = ['title', 'description', 'user__first_name', 'user__last_name']
#     readonly_fields = ['created_at', 'file_size']
#
#     def file_size_display(self, obj):
#         if obj.file_size:
#             return f"{obj.file_size / 1024:.2f} KB"
#         return "بدون فایل"
#
#     file_size_display.short_description = 'حجم فایل'


# @admin.register(Evaluation)
# class EvaluationAdmin(admin.ModelAdmin):
#     list_display = ['user', 'period', 'participation_count', 'audio_count', 'score', 'created_at']
#     list_filter = ['period', 'created_at', 'user__role__name']
#     search_fields = ['user__full_name']
#     readonly_fields = ['created_at']
#
#     def get_queryset(self, request):
#         qs = super().get_queryset(request)
#         return qs.order_by('-created_at')


@admin.register(Evaluation)
class EvaluationAdmin(admin.ModelAdmin):
    list_display = [
        "user",
        "period",
        "participation_count",
        "audio_count",
        "score",
        "created_at",
    ]
    list_filter = ["period", "created_at", RoleFilter]  # حذف user__role__name
    search_fields = ["user__first_name", "user__last_name"]
    readonly_fields = ["created_at"]

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        return qs.order_by("-created_at")
