defmodule ZeroPhoenix.PersonView do
  use ZeroPhoenix.Web, :view

  def render("index.json", %{people: people}) do
    %{data: render_many(people, ZeroPhoenix.PersonView, "person.json")}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, ZeroPhoenix.PersonView, "person.json")}
  end

  def render("person.json", %{person: person}) do
    %{id: person.id,
      first_name: person.first_name,
      last_name: person.last_name,
      username: person.username,
       email: person. email}
  end
end
