from django import forms
from .models import Works, Lives


# Form for Works and Lives data
class WorksAndLivesForm(forms.Form):
    person_name = forms.CharField(max_length=100)
    company_name = forms.CharField(max_length=100)
    salary = forms.DecimalField(max_digits=10, decimal_places=2)
    
    street = forms.CharField(max_length=200)
    city = forms.CharField(max_length=100)


class CompanyForm(forms.Form):
    company_name = forms.CharField(max_length=100)
    
