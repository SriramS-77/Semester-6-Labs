from django.shortcuts import render
from django.http import HttpResponse
from datetime import date
import calendar
from calendar import HTMLCalendar

#def index(request):
#    return HttpResponse("<H2>HEY! Welcome to Edureka! </H2>")

def index(request, year=date.today().year, month=date.today().month):
    year = int(year)
    month = int(month)
    if year < 1900 or year > 2099: year = date.today().year
    month_name = calendar.month_name[month]
    title = "MyClub Event Calendar - %s %s" % (month_name,year)
    cal = HTMLCalendar().formatmonth(year, month)
    # return HttpResponse("<h1>%s</h1><p>%s</p>" % (title, cal))
    return render(request, 'base.html', {'title': title, 'cal': cal})
