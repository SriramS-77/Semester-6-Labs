from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('webdirApp/', include('webdirApp.urls')),
    path('workApp/', include('workApp.urls')),
]
