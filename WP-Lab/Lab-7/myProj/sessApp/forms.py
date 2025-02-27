from django import forms


SUBJECTS = (('Mathematics', 'Mathematics'), ('English', 'English'), ('Computer Science', 'Computer Science'), ('Physics', 'Physics'), ('Chemistry', 'Chemistry'), ('Biology', 'Biology'))

class StudentForm(forms.Form):
    name = forms.CharField(required=True)
    rollno = forms.CharField(required=True)
    subject = forms.ChoiceField(widget=forms.Select, choices=SUBJECTS)
