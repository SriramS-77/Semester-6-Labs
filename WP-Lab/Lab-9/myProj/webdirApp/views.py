from django.shortcuts import render, redirect
from .models import Category, Page
from .forms import CategoryForm, PageForm

# View to display the directory
def directory_view(request):
    categories = Category.objects.all()
    return render(request, 'webdirApp/directory.html', {'categories': categories})

# View to display and submit the Category form
def add_category(request):
    if request.method == 'POST':
        form = CategoryForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('webdirApp')
    else:
        form = CategoryForm()
    return render(request, 'webdirApp/add_category.html', {'form': form})

# View to display and submit the Page form
def add_page(request):
    if request.method == 'POST':
        form = PageForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('webdirApp')
    else:
        form = PageForm()
    return render(request, 'webdirApp/add_page.html', {'form': form})
