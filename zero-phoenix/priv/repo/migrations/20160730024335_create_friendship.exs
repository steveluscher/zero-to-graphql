defmodule ZeroPhoenix.Repo.Migrations.CreateFriendship do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :person_id, references(:people, on_delete: :nothing)
      add :friend_id, references(:people, on_delete: :nothing)

      timestamps()
    end

    create index(:friendships, [:person_id])
    create index(:friendships, [:friend_id])
  end
end
