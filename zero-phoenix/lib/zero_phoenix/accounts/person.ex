defmodule ZeroPhoenix.Accounts.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZeroPhoenix.Accounts.Person
  alias ZeroPhoenix.Accounts.Friendship

  schema "people" do
    field(:email, :string)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:username, :string)

    has_many(:friendships, Friendship)
    has_many(:friends, through: [:friendships, :friend])

    timestamps()
  end

  @doc false
  def changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :username, :email])
    |> validate_required([:first_name, :last_name, :username, :email])
  end
end
