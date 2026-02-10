from django.urls import path
from . import views
from django.contrib.auth.views import LogoutView
from django.views.generic import TemplateView

app_name = "users"

urlpatterns = [
    path("login/", views.login_view, name="login"),
    path("users/", views.dashboard, name="dashboard"),
    path("profile/<int:user_id>/", views.user_profile, name="user_profile"),
    path("register/", views.register_user, name="register_user"),
    path("logout/", LogoutView.as_view(next_page="users:login"), name="logout"),
    path(
        "submit-participation/", views.submit_participation, name="submit_participation"
    ),
    path("management/", views.management_dashboard, name="management_dashboard"),
    path("user_management/", views.user_management, name="user_management"),
    path("user_details/<int:employee_id>/", views.user_details, name="user_details"),
    path("evaluation-panel/", views.evaluation_panel, name="evaluation_panel"),
    path(
        "process-participation/<int:participation_id>/",
        views.process_participation,
        name="process_participation",
    ),
    path(
        "review-participation/<int:participation_id>/",
        views.review_participation,
        name="review_participation",
    ),
    path("dashboard/", views.dashboard, name="dashboard"),
    path(
        "management-dashboard/", views.management_dashboard, name="management_dashboard"
    ),
    path(
        "load-more-participations/",
        views.load_more_participations,
        name="load_more_participations",
    ),
    path("chat/", views.chat_page, name="chat_page"),
    path("send-message/", views.send_message, name="send_message"),
    path("change-password/", views.change_password_view, name="change_password"),
    path("import-employees/", views.import_employees_view, name="import_employees"),
    path(
        "robots.txt",
        TemplateView.as_view(template_name="robots.txt", content_type="text/plain"),
    ),
    path("switch_role/", views.switch_role, name="switch_role"),
    path("manage-self-menu/", views.manage_self_menu, name="manage_self_menu"),
    path("food-reservation/", views.food_reservation_view, name="food_reservation"),
    path(
        "restaurant_management_dashboard/",
        views.restaurant_management_dashboard,
        name="restaurant_management_dashboard",
    ),
    path("food-delivery/", views.food_delivery_page, name="food_delivery_page"),
    path("search-employees/", views.search_employees, name="search_employees"),
    path(
        "referral/create/<int:participation_id>/",
        views.referral_create,
        name="referral_create",
    ),
    path("ajax/search-org-units/", views.search_org_units, name="search_org_units"),
    path("referrals/inbox/", views.referrals_inbox, name="referrals_inbox"),
    path("referral/<int:referral_id>/", views.referral_detail, name="referral_detail"),
    path(
        "notifications/create/", views.notification_create, name="notification_create"
    ),
    path("notifications/", views.notifications_view, name="notifications"),
    path("family/", views.family_management, name="family_management"),
    path("family/add/", views.add_dependent, name="add_dependent"),
    path("insurance_info/", views.insurance_info, name="insurance_info"),
    path("manage_bimeh/", views.manage_bimeh, name="manage_bimeh"),
    path(
        "food-reservation-for-others/",
        views.food_reservation_for_others,
        name="food_reservation_for_others",
    ),
    path(
        "get-employee-reservation-info/",
        views.get_employee_reservation_info,
        name="get_employee_reservation_info",
    ),
]
