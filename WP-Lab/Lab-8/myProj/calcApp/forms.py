from django import forms

class CGPAForm(forms.Form):
    name = forms.CharField(required=True)
    marks = forms.IntegerField(required=True, min_value=0, max_value=500)
