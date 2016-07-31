defmodule ZeroPhoenix.Friendship do
  use ZeroPhoenix.Web, :model

  @required_fields ~w(person_id friend_id)
  @optional_fields ~w()

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
    |> cast(params, [:person_id, :friend_id])
    |> validate_required([:person_id, :friend_id])
  end
end
