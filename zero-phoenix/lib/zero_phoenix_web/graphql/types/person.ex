defmodule ZeroPhoenixWeb.Graphql.Types.Person do
  use Absinthe.Schema.Notation

  import Ecto

  alias ZeroPhoenix.Repo

  @desc "a person"
  object :person do
    @desc "unique identifier for the person"
    field(:id, non_null(:string))

    @desc "first name of a person"
    field(:first_name, non_null(:string))

    @desc "last name of a person"
    field(:last_name, non_null(:string))

    @desc "username of a person"
    field(:username, non_null(:string))

    @desc "email of a person"
    field(:email, non_null(:string))

    @desc "a list of friends for our person"
    field :friends, list_of(:person) do
      resolve(fn _, %{source: person} ->
        {:ok, Repo.all(assoc(person, :friends))}
      end)
    end
  end
end
