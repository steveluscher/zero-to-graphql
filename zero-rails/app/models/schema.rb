PersonType = GraphQL::ObjectType.define do
  name 'Person'
  description 'Somebody to lean on'

  field :id, !types.ID
  field :firstName, !types.String, property: :first_name
  field :lastName, !types.String, property: :last_name
  field :email, !types.String, 'Like a phone number, but spammier'
  field :username, !types.String, 'Use this to log in to your computer'
  field :friends, -> { types[PersonType] }, 'Some people to lean on'
  field :fullName do
    type !types.String
    description 'Every name, all at once'
    resolve -> (obj, args, ctx) { "#{obj.first_name} #{obj.last_name}" }
  end
end

QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The root of all queries'

  field :allPeople do
    type types[PersonType]
    description 'Everyone in the Universe'
    resolve -> (obj, args, ctx) { Person.all }
  end
  field :person do
    type PersonType
    description 'The person associated with a given ID'
    argument :id, !types.ID
    resolve -> (obj, args, ctx) { Person.find(args[:id]) }
  end
end

Schema = GraphQL::Schema.new(
  query: QueryType,
)
