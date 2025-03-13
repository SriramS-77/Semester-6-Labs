from django.shortcuts import render
from .forms import RegrationForm

def index(request):
    username, password, email_id, contact_number = "None", "None", "None", "None"
    if request.method == "POST":
        myForm = RegrationForm(request.POST)
        if myForm.is_valid():
            username, password, email_id, contact_number = myForm.cleaned_data['username'], myForm.cleaned_data['password'], myForm.cleaned_data['email_id'], myForm.cleaned_data['contact_number']
            email_id = "None" if email_id == "" else email_id
            request.session['username'], request.session['password'], request.session['email_id'], request.session['contact_number'] = username, password, email_id, contact_number
            return render(request, 'details.html', {"username" : username,
                                                    "password": password,
                                                    "email_id": email_id,
                                                    "contact_number": contact_number})

    else:   
        return render(request, 'register.html', {"form": RegrationForm(request.POST or None)})
