defmodule ZeroPhoenixWeb.PersonController do
  use ZeroPhoenixWeb, :controller

  alias ZeroPhoenix.Accounts
  alias ZeroPhoenix.Accounts.Person

  action_fallback ZeroPhoenixWeb.FallbackController

  def index(conn, _params) do
    people = Accounts.list_people()
    render(conn, "index.json", people: people)
  end

  def create(conn, %{"person" => person_params}) do
    with {:ok, %Person{} = person} <- Accounts.create_person(person_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", person_path(conn, :show, person))
      |> render("show.json", person: person)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Accounts.get_person!(id)
    render(conn, "show.json", person: person)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Accounts.get_person!(id)

    with {:ok, %Person{} = person} <- Accounts.update_person(person, person_params) do
      render(conn, "show.json", person: person)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Accounts.get_person!(id)
    with {:ok, %Person{}} <- Accounts.delete_person(person) do
      send_resp(conn, :no_content, "")
    end
  end
end
