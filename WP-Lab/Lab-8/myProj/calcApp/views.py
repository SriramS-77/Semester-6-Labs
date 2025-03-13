from django.shortcuts import render
from .forms import CGPAForm

def index(request):
    if request.method == "POST":
        myForm = CGPAForm(request.POST)
        if myForm.is_valid():
            name, marks = myForm.cleaned_data['name'], myForm.cleaned_data['marks']
            
            cgpa = marks / 50

            return render(request, 'cgpa_result.html', {"CGPA": cgpa, "name": name})

    else:   
        return render(request, 'calc.html', {"form": CGPAForm(request.POST or None)})
