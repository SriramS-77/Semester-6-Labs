from django.urls import path
from . import views

urlpatterns = [
    path('', views.directory_view, name='webdirApp'),
    path('add_category/', views.add_category, name='add_category'),
    path('add_page/', views.add_page, name='add_page'),
]
