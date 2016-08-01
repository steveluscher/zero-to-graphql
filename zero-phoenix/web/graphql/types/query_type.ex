defmodule ZeroPhoenix.QueryType do
  alias GraphQL.Type.{ObjectType, String}
  alias ZeroPhoenix.Person
  alias ZeroPhoenix.PersonType
  alias ZeroPhoenix.Repo

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
    Person |> Repo.get(id)
  end
  def resolve(_root, _args, _ctx), do: "person does not exist"
end
