from django import forms

class RegrationForm(forms.Form):
    username = forms.CharField(required=True)
    password = forms.CharField(required=True, widget=forms.PasswordInput)
    email_id = forms.EmailField(required=False)
    contact_number = forms.IntegerField(required=False, min_value=1000000000, max_value=9999999999)
