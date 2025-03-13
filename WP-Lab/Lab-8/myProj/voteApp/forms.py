from django import forms

CHOICES = (("Good", "Good"), ("Satisfactory", "Satisfactory"), ("Bad", "Bad"))

class VoteForm(forms.Form):
    vote = forms.ChoiceField(required=True, widget=forms.RadioSelect(), choices=CHOICES)
