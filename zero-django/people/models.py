from django.contrib.auth.models import AbstractUser
from django.core.urlresolvers import reverse
from django.db import models

class Person(AbstractUser):
    class Meta:
        app_label = 'people'
        db_table = 'person'

    friends = models.ManyToManyField('self')

    def as_json(self):
        out = dict(
            id=str(self.id),
            first_name=self.first_name,
            last_name=self.last_name,
            email=self.email,
            username=self.username,
            friends = [
                reverse('person', args=[friend.id])
                for friend in self.friends.all()
            ],
        )
        return out
