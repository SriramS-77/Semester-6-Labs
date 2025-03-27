from django.shortcuts import render, redirect
from .forms import BookForm, AuthorForm, PublisherForm, SearchForm
from .models import Book, Author, Publisher

def index(request):
    bookForm, authorForm, publisherForm = BookForm(), AuthorForm(), PublisherForm()
    
    return render(request, "populate.html", {
        "bookForm": bookForm,
        "authorForm": authorForm,
        "publisherForm": publisherForm
    })


def bookIndex(request):
    if request.method == "POST":
        form = BookForm(request.POST)
        if form.is_valid():
            print("Valid")
            data = form.cleaned_data
            book = Book.objects.create(
                title = data["title"],
                publication_date = data["publication_date"],
                publisher = Publisher.objects.get(name=data["publisher"])
            )
            author_names = data["authors"].split()
            
            for author_name in author_names:
                author = Author.objects.filter(first_name=author_name)[0]
                book.authors.add(author)

            return redirect("index")
    print("Not Valid")

def authorIndex(request):
    if request.method == "POST":
        form = AuthorForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            author = Author.objects.create(
                first_name = data["first_name"],
                last_name = data["last_name"],
                email = data["email"]
            )
            return redirect("index")

def publisherIndex(request):
    if request.method == "POST":
        form = PublisherForm(request.POST)
        if form.is_valid():
            data = form.cleaned_data
            publisher = Publisher.objects.create(
                name = data["name"],
                street_address = data["street_address"],
                city = data["city"],
                state_province = data["state_province"],
                country = data["country"],
                website = data["website"]
            )
            return redirect("index")


def retrieve(request):
    if request.method == "POST":
        form = SearchForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data["name"]
            book = Book.objects.filter(title=name)[0]
            bookName = book.title
            bookDate = book.publication_date
            authors = book.authors
            print([i for i in authors.all()])
            author = None
            for a in authors.all():
                author = a
                break
            if author is not None:
                authorName = author.first_name
                authorEmail = author.email
            else:
                authorName = None
                authorEmail = None

            publisher = book.publisher
            publisherName = publisher.name
            publisherWebsite = publisher.website

            context = {"authorName": authorName,
                        "authorEmail": authorEmail,
                        "publisherName": publisherName,
                        "publisherWebsite": publisherWebsite,
                        "bookName": bookName,
                        "bookDate": bookDate}
            print(context)

            return render(request, "retrieve.html", context)
    else:
        form = SearchForm()
    return render(request, "retrieve.html", {"form": form})
