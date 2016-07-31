defmodule ZeroPhoenix.PersonTest do
  use ZeroPhoenix.ModelCase

  alias ZeroPhoenix.Person

  @valid_attrs %{" email": "some content", first_name: "some content", last_name: "some content", username: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Person.changeset(%Person{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Person.changeset(%Person{}, @invalid_attrs)
    refute changeset.valid?
  end
end
