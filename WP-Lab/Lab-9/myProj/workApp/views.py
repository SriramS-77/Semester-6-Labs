from django.shortcuts import render, redirect
from .forms import WorksAndLivesForm, CompanyForm
from .models import Works, Lives

# View to insert data into the WORKS and LIVES tables
def insert_works(request):
    if request.method == 'POST':
        form = WorksAndLivesForm(request.POST)
        if form.is_valid():
            # Create and save the Works record
            person_name = form.cleaned_data['person_name']
            company_name = form.cleaned_data['company_name']
            salary = form.cleaned_data['salary']
            works_instance = Works.objects.create(
                person_name=person_name,
                company_name=company_name,
                salary=salary
            )

            # Create and save the Lives record
            street = form.cleaned_data['street']
            city = form.cleaned_data['city']
            Lives.objects.create(
                person_name=person_name,
                street=street,
                city=city
            )

            return redirect('retrieve_people')
    else:
        form = WorksAndLivesForm()

    return render(request, 'workApp/insert_works.html', {'form': form})


# View to retrieve names of people working for a specific company
def retrieve_people(request):
    people = None
    if request.method == 'POST':
        form = CompanyForm(request.POST)
        if form.is_valid():
            company_name = form.cleaned_data['company_name']
            people_in_company = Works.objects.filter(company_name=company_name)
            people = []
            #people_city_pairs = [[(work.name, life.city) for life in Lives.objects.get(person_name=work.person_name)] for work in people_in_company]
            #people_in_company = [(work.person_name, Lives.objects.get(person_name=work.person_name).city)
            #                     for work in people_in_company]
            for work in people_in_company:
                for life in Lives.objects.filter(person_name=work.person_name):
                    people.append((work.person_name, life.city))

    else:
        form = CompanyForm()

    return render(request, 'workApp/retrieve_people.html', {'form': form, 'people_in_company': people})
