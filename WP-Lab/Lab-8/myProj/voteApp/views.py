from django.shortcuts import render
from .forms import VoteForm

VOTES = {"Good": 0,
        "Satisfactory": 0,
        "Bad": 0}

def index(request):
    if request.method == "POST":
        myForm = VoteForm(request.POST)
        if myForm.is_valid():
            vote = myForm.cleaned_data['vote']
            VOTES[vote] += 1
            print(VOTES)
            total_votes = sum(list(VOTES.values()))
            context = {"vote_good": f"{VOTES["Good"]/total_votes:.2%}",
                        "vote_satisfactory": f"{VOTES["Satisfactory"]/total_votes:.2%}",
                        "vote_bad": f"{VOTES["Bad"]/total_votes:.2%}"}
            print(context)
            return render(request, 'result.html', context)

    else:   
        return render(request, 'vote.html', {"form": VoteForm(request.POST or None)})
