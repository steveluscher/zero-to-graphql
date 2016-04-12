from django.core import serializers
from django.forms.models import model_to_dict
from django.http import JsonResponse

from .models import Person

def index(request):
    people = {
        'people': [person.as_json() for person in Person.objects.all()],
    }
    return JsonResponse(people, json_dumps_params={'indent': 2}, safe=False)

def show(request, person_id):
    person = {
        'person': Person.objects.get(pk=person_id).as_json(),
    }
    return JsonResponse(person, json_dumps_params={'indent': 2}, safe=False)
