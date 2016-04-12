from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^people/$', views.index),
    url(r'^people/([1-9][0-9]*)/$', views.show, name='person'),
]
