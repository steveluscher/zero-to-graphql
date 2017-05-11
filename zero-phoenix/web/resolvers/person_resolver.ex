defmodule ZeroPhoenix.PersonResolver do

  alias ZeroPhoenix.Repo
  
  def find(%{id: id}, _info) do
    case ZeroPhoenix.Person |> Repo.get(id) do
      nil  -> {:error, "Person id #{id} not found"}
      person -> {:ok, person}
    end
  end
end
