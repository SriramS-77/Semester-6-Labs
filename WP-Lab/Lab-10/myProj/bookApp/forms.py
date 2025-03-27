from django import forms
from .models import Author, Publisher, Book

class AuthorForm(forms.Form):
    first_name = forms.CharField(max_length=100)
    last_name = forms.CharField(max_length=100)
    email = forms.EmailField()

class PublisherForm(forms.Form):
    name = forms.CharField(max_length=100)
    street_address = forms.CharField(max_length=255)
    city = forms.CharField(max_length=100)
    state_province = forms.CharField(max_length=100)
    country = forms.CharField(max_length=100)
    website = forms.URLField()

class BookForm(forms.Form):
    title = forms.CharField(max_length=100)
    publication_date = forms.DateField()
    authors = forms.CharField(max_length=300)
    publisher = forms.CharField(max_length=100)

class SearchForm(forms.Form):
    name = forms.CharField(max_length=100)
