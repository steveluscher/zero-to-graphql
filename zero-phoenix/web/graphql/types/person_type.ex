# PersonType = GraphQL::ObjectType.define do
#   name 'Perosn'
#   description '...'
#
#   field :firstName, !types.String, property: :first_name
#   field :lastName, !types.String, property: :last_name
#   field :email, !types.String
#   field :username, !types.String
#   field :id, !types.String
#   field :friends do
#     type -> { types[PersonType] }
#     resolve -> (person, _args, _ctx) { person.friends }
#   end
# end

defmodule ZeroPhoenix.PersonType do
  alias ZeroPhoenix.PersonType
  alias GraphQL.Type.{ObjectType, List, NonNull, String}

  def type do
    %ObjectType{
      name: "PersonType",
      description: "friends of a given person",
      fields: %{
        id: %{type: %NonNull{ofType: %String{}}, description: "unique identifier for the person" },
        firstName: %{type: %String{}, description: "first name of the person"},
        lastName: %{type: %String{}, description: "last name of the person"},
        email: %{type: %String{}, description: "email of the person"},
        username: %{type: %String{}, description: "username of the person"},
        friends: %{
          type: %List{ofType: PersonType},
          description: "a list of friends for our person",
          resolve: &resolve/3
        }
      }
    }
  end

  def resolve(person, _args, _ctx) do
    # person
    # |> Repo.preload(friends)
  end
end
