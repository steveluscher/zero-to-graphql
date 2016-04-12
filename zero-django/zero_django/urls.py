from django.conf.urls import url, include
from django.contrib import admin
from django.views.decorators.csrf import csrf_exempt
from graphene.contrib.django.views import GraphQLView

urlpatterns = [
    url(r'^', include('people.urls')),
]
