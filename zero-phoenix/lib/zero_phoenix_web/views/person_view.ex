defmodule ZeroPhoenixWeb.PersonView do
  use ZeroPhoenixWeb, :view
  alias ZeroPhoenixWeb.PersonView

  def render("index.json", %{people: people}) do
    %{data: render_many(people, PersonView, "person.json")}
  end

  def render("show.json", %{person: person}) do
    %{data: render_one(person, PersonView, "person.json")}
  end

  def render("person.json", %{person: person}) do
    %{id: person.id,
      first_name: person.first_name,
      last_name: person.last_name,
      username: person.username,
      email: person.email}
  end
end
