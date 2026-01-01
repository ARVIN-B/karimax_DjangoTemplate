from django.urls import path
from . import views

app_name = 'evaluations'

urlpatterns = [
    path('criteria/', views.criteria_list, name='criteria_list'),
    path('criteria/add/', views.criteria_create, name='criteria_create'),
    path('criteria/<int:pk>/', views.criteria_detail, name='criteria_detail'),
    path('employee/<int:employee_id>/', views.employee_evaluation, name='employee_evaluation'),
    path('reports/', views.evaluation_reports, name='evaluation_reports'),
]