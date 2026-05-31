from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from users import views  # اضافه کردن این برای دسترسی به login_view
from django.views.generic import RedirectView
# handler404 = 'users.views.custom_404'  # اضافه کردن این خط

urlpatterns = [
    path('admin/', admin.site.urls),
    path('users/', include('users.urls', namespace='users')),
    path('evaluations/', include('evaluations.urls')),
    path('login/', views.login_view, name='login'),
    path('', RedirectView.as_view(url='/login/', permanent=True)),
    path("manifest.json", views.manifest),
    path(".well-known/assetlinks.json", views.assetlinks),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)