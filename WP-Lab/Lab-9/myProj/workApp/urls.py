from django.urls import path
from . import views

urlpatterns = [
    path('', views.insert_works, name='insert_works'),
    path('retrieve', views.retrieve_people, name='retrieve_people'),
]
