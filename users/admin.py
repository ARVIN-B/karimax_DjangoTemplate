from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
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


@admin.register(Factory)
class FactoryAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "location",
        "holding",
        "manager",
        "created_at",
        "department_count",
        "is_committee",
        "employee_count",
    ]
    search_fields = ["name", "location", "holding"]
    list_filter = ["holding", "created_at", "is_committee"]  # اضافه holding به فیلتر
    readonly_fields = ["created_at"]

    def department_count(self, obj):
        return obj.departments.count()

    department_count.short_description = "مجموع بخش‌ها"

    def employee_count(self, obj):
        # جمع کارمندان از تمام بخش‌ها و زیربخش‌ها
        total = 0
        for dept in obj.departments.all():
            for subdept in dept.subdepartments.all():
                total += subdept.assigned_employees.count()
        return total

    employee_count.short_description = "مجموع کارمندان"


@admin.register(Holding)
class HoldingAdmin(admin.ModelAdmin):
    list_display = ["name", "location", "manager", "created_at", "factory_count"]
    search_fields = ["name", "location"]
    list_filter = ["created_at"]
    readonly_fields = ["created_at"]

    def factory_count(self, obj):
        return obj.factories.count()

    factory_count.short_description = "تعداد کارخانه‌ها"


@admin.register(Department)
class DepartmentAdmin(admin.ModelAdmin):
    list_display = [
        "name",
        "factory",
        "holding_name",
        "factory_location",
        "manager",
        "created_at",
        "subdepartment_count",
        "is_committee",
        "employee_count",
    ]
    list_filter = ["factory__holding", "factory", "created_at", "is_committee"]
    search_fields = ["name", "factory__name", "factory__holding__name"]
    readonly_fields = ["created_at"]

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
        "supervisor",
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


@admin.register(Employee)
class EmployeeAdmin(UserAdmin):
    add_form_template = "admin/users/employee_add_form.html"
    change_form_template = "admin/users/employee_change_form.html"

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
            "مجوزها",
            {
                "fields": (
                    "is_active",
                    "is_staff",
                    "is_superuser",
                    "is_first_login",
                    "can_serve_foods",
                    "unlimit_reservation",
                    "can_reserve_management_food",
                    "factory_bimeh",
                    "holding_bimeh",
                ),
                "classes": ("collapse",),
            },
        ),
        (
            "تاریخ‌ها",
            {"fields": ("last_login", "date_joined"), "classes": ("collapse",)},
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
    )

    # --- فرم ایجاد ---
    add_fieldsets = (
        (
            None,
            {
                "classes": ("wide",),
                "fields": (
                    "national_id",
                    "personnel_code",  # اضافه شد
                    "first_name",
                    "last_name",
                    "phone_number",
                    "assigned_subdepartments",
                    "roles",
                    "can_serve_foods",
                    "unlimit_reservation",
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
        "date_joined",
        "food_receiver_role_display",
        "food_receiver_location",
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
        "is_active",
        "is_staff",
        "is_superuser",
        "is_first_login",
        "date_joined",
        "food_receiver_role",
        "food_receiver_factory",
        "food_receiver_holding",
        # 'personnel_code' رو نمی‌ذاریم چون فیلتر روی CharField معنی نداره (مگر با SimpleListFilter)
    ]

    ordering = ["personnel_code", "last_name", "first_name"]  # مرتب‌سازی بهتر
    readonly_fields = ["date_joined", "last_login"]

    # --- نمایش کد پرسنلی در لیست (اگر بخوای لینک بشه) ---
    def personnel_code_display(self, obj):
        return obj.personnel_code or "-"

    personnel_code_display.short_description = "کد پرسنلی"

    # --- بقیه متدها بدون تغییر ---
    def roles_display(self, obj):
        # ... (همون کد قبلی)
        pass

    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

    full_name.short_description = "نام کامل"

    def assigned_subdepartments_display(self, obj):
        return ", ".join([sd.name for sd in obj.assigned_subdepartments.all()]) or "-"

    assigned_subdepartments_display.short_description = "زیربخش‌های تخصیص‌یافته"

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
