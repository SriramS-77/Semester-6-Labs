from django.shortcuts import render
from .forms import RegForm
from django.views.decorators.csrf import csrf_protect


@csrf_protect
def index(request):
    manufacturer, model = "None", "None"
    if request.method == "POST":
        # Get the posted form
        myForm = RegForm(request.POST)
        if myForm.is_valid():
            manufacturer, model = myForm.cleaned_data['manufacturer'], myForm.cleaned_data['model']
            context = {'manufacturer': manufacturer, 'model': model}
            return render(request, 'info.html', context)

    else:   
        myForm = RegForm(request.POST or None)
    
    context = {'form': myForm}
    return render(request, "form.html", context)
