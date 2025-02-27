from django import forms

CHOICES = (('BMW', 'BMW'), ('Toyota', 'Toyota'), ('Maruti Suzuki', 'Maruti Suzuki'), ('Lamborghini', 'Lamborghini'), ('Tesla', 'Tesla'))

class RegForm(forms.Form):
    manufacturer = forms.ChoiceField(widget=forms.Select, choices=CHOICES)
    model = forms.CharField(required=True)
