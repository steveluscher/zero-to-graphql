# QueryType = GraphQL::ObjectType.define do
#   name 'Query'
#   description 'RootQueryType'
#
#   field :person do
#     type PersonType
#     argument :id, !types.String
#     resolve -> (_root, args, _ctx) { Person.find(args[:id]) }
#   end
# end

defmodule ZeroPhoenix.QueryType do
  alias GraphQL.Type.{ObjectType, String}
  alias ZeroPhoenix.Person
  alias ZeroPhoenix.PersonType
  alias ZeroPhoenix.Repo

  import Ecto.Query

  def type do
    %ObjectType{
      name: "QueryType",
      description: "the root object type",
      fields: %{
        person: %{
          type: PersonType,
          resolve: &resolve/3,
          description: "PersonType",
          args: %{
            id: %{type: %String{}, description: "unique identifier for the person"},
          }
        }
      }
    }
  end

  def resolve(_root, %{id: id}, _ctx) do
    query = from p in Person,
      where: p.id == ^id,
      select: p
    Repo.one(query)
  end
  def resolve(_root, _args, _ctx), do: "person does not exist"

  # def greeting(_, %{name: name}, _), do: "Hello, #{name}!"
  # def greeting(_, _, _), do: "Hello, world!"
end

# alias ZeroPhoenix.GraphQLSchema
# GraphQL.execute(GraphQLSchema.schema, "{ person(id: 1) }" )
