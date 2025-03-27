from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name="index"),
    path('addAuthor/', views.authorIndex, name="Add Author"),
    path('addPublisher/', views.publisherIndex, name="Add Publisher"),
    path('addBook/', views.bookIndex, name="Add Book"),
    path('retrieve/', views.retrieve, name="RetrieveRecords")
]
