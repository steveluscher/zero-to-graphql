import graphene

from people.models import Person

class PersonType(graphene.ObjectType):
    email = graphene.String(description='Like a phone number, but often longer')
    first_name = graphene.String()
    friends = graphene.List(lambda: PersonType, description='Mostly less strange people')
    full_name = graphene.String(description='Pretty much all of your name')
    id = graphene.String()
    last_name = graphene.String()
    username = graphene.String(description='Something you forget often')

    def resolve_friends(self, args, context, info):
        return self.friends.all()
    def resolve_full_name(self, args, context, info):
        return '{} {}'.format(self.first_name, self.last_name)

class QueryType(graphene.ObjectType):
    all_people = graphene.List(PersonType, description='A few billion people')
    person = graphene.Field(
        PersonType,
        id=graphene.ID(),
        description='Just one person belonging to an ID',
    )

    def resolve_all_people(self, args, context, info):
        return Person.objects.all()
    def resolve_person(self, args, context, info):
        id = args.get('id')
        return Person.objects.get(pk=id)

schema = graphene.Schema(query=QueryType)
