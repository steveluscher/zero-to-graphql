defmodule ZeroPhoenix.Person do
  use ZeroPhoenix.Web, :model

  @required_fields ~w(first_name last_name username email)

  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :email, :string

    has_many :friendships, ZeroPhoenix.Friendship #, on_delete: :delete_all
    has_many :friends, through: [:friendships, :friend] #, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
