defmodule ZeroPhoenix.Graphql.Schema do
  use Absinthe.Schema

  import Ecto

  alias ZeroPhoenix.Friendship
  alias ZeroPhoenix.Person
  alias ZeroPhoenix.Repo

  query do
    field :person, type: :person do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _info ->
        case Person |> Repo.get(id) do
          nil  -> {:error, "Person id #{id} not found"}
          person -> {:ok, person}
        end
      end
    end
  end

  @desc "a person"
  object :person do
    @desc "unique identifier for the person"
    field :id, :string

    @desc "first name of a person"
    field :first_name, :string

    @desc "last name of a person"
    field :last_name, :string

    @desc "username of a person"
    field :username, :string

    @desc "email of a person"
    field :email, :string

    @desc "a list of friends for our person"
    field :friends, list_of(:person) do
      resolve fn _, %{source: person} ->
        {:ok, Repo.all(assoc(person, :friends))}
      end
    end
  end
end
