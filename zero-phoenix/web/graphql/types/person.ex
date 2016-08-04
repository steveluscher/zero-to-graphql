defmodule ZeroPhoenix.Graphql.Types.Person do
  use Absinthe.Schema.Notation

  import Ecto

  alias ZeroPhoenix.Repo

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
