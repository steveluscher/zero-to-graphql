defmodule ZeroPhoenix.Friendship do
  use ZeroPhoenix.Web, :model

  @required_fields [:person_id, :friend_id]
  @optional_fields []

  schema "friendships" do
    belongs_to :person, ZeroPhoenix.Person
    belongs_to :friend, ZeroPhoenix.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields, @optional_fields)
  end
end
