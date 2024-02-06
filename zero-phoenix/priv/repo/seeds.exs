# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ZeroPhoenix.Repo.insert!(%ZeroPhoenix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ZeroPhoenix.Repo
alias ZeroPhoenix.Accounts.Person
alias ZeroPhoenix.Accounts.Friendship

# reset the datastore
Repo.delete_all(Friendship)
Repo.delete_all(Person)

# insert people
me =
  Repo.insert!(%Person{
    first_name: "Steven",
    last_name: "Luscher",
    email: "steveluscher@fb.com",
    username: "steveluscher"
  })

dhh =
  Repo.insert!(%Person{
    first_name: "David",
    last_name: "Heinemeier Hansson",
    email: "dhh@37signals.com",
    username: "dhh"
  })

ezra =
  Repo.insert!(%Person{
    first_name: "Ezra",
    last_name: "Zygmuntowicz",
    email: "ezra@merbivore.com",
    username: "ezra"
  })

matz =
  Repo.insert!(%Person{
    first_name: "Yukihiro",
    last_name: "Matsumoto",
    email: "matz@heroku.com",
    username: "matz"
  })

me
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: me.id, friend_id: matz.id})
|> Repo.insert()

dhh
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: dhh.id, friend_id: ezra.id})
|> Repo.insert()

dhh
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: dhh.id, friend_id: matz.id})
|> Repo.insert()

ezra
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: ezra.id, friend_id: dhh.id})
|> Repo.insert()

ezra
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: ezra.id, friend_id: matz.id})
|> Repo.insert()

matz
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: matz.id, friend_id: me.id})
|> Repo.insert()

matz
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: matz.id, friend_id: ezra.id})
|> Repo.insert()

matz
|> Ecto.build_assoc(:friendships)
|> Friendship.changeset(%{person_id: matz.id, friend_id: dhh.id})
|> Repo.insert()
