defmodule ZeroPhoenixWeb.FriendshipTest do
  use ZeroPhoenix.ModelCase

  alias ZeroPhoenix.Friendship

  @valid_attrs %{friend_id: 42, person_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Friendship.changeset(%Friendship{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Friendship.changeset(%Friendship{}, @invalid_attrs)
    refute changeset.valid?
  end
end
