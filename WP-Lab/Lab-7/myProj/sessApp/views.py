from django.shortcuts import render
from .forms import StudentForm
from django.views.decorators.csrf import csrf_protect


def index(request):
    name, rollno, subject = "None", "None", "None"
    if request.method == "POST":
        # Get the posted form
        myForm = StudentForm(request.POST)
        if myForm.is_valid():
            name, rollno, subject = myForm.cleaned_data['name'], myForm.cleaned_data['rollno'], myForm.cleaned_data['subject']
            request.session['name'], request.session['rollno'] , request.session['subject'] = name, rollno, subject
            return render(request, 'second.html', {"name" : request.session['name'],
                                                "rollno": request.session['rollno'],
                                                "subject": request.session['subject']})

    else:   
        myForm = StudentForm(request.POST or None)
    
    context = {'form': myForm}
    return render(request, "first.html", context)

def studentInfo(request):
    if request.session.has_key('name'):
        return render(request, 'second.html', {"name" : request.session['name'],
                                                "rollno": request.session['rollno'],
                                                "subject": request.session['subject']})
    else:
        return render(request, 'first.html', {"form" : StudentForm(request.POST or None)})
