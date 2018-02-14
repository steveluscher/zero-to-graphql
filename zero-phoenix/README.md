# Phoenix Example

The purpose of this example is to provide details as to how one would go about using GraphQL with the Phoenix Web Framework.  Thus, I have created two major sections which should be self explanatory: Quick Installation and Tutorial Installation.

## Getting Started

## Software requirements

- [Elixir 1.6.1 or higher](http://elixir-lang.org/install.html)

- [Phoenix 1.3.0 or higher](http://www.phoenixframework.org/docs/installation)

- PostgreSQL 10.2.0 or higher

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql). (Tag 'graphql')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/graphql).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Quick Installation

1.  clone this repository

    ```
    $ git clone git@github.com:steveluscher/zero-to-graphql.git
    ```

2.  change directory location

    ```
    $ cd /path/to/zero-phoenix
    ```

2.  install dependencies

    ```
    $ mix deps.get
    ```

3.  create, migrate, and seed the database

    ```
    $ mix ecto.setup
    ```

4.  start the server

    ```
    $ mix phx.server
    ```

5.  navigate to our application within the browser

    ```
    $ open http://localhost:4000/graphiql
    ```

6.  enter and run GraphQL query

    ```
    {
     person(id: "1") {
       firstName
       lastName
       username
       email
       friends {
         firstName
         lastName
         username
         email
       }
     }
    }
    ```

    Note:  The GraphQL query is responding with same response but different shape
           within the GraphiQL browser because Elixir Maps perform no ordering on insertion.

## Tutorial Installation

1.  create the project

    ```
    $ mix phx.new zero_phoenix --no-brunch
    ```

    Note:  Just answer 'Y' to all the prompts that appear.

2.  change the folder name to more consistent with the GraphQL folders

    ```
    $ mv zero_phoenix zero-phoenix
    ```

3.  switch to the project directory

    ```
    $ cd zero-phoenix
    ```

4.  update `username` and `password` database credentials which appears at the bottom  of the following files:

    ```
    config/dev.exs
    config/test.exs
    ```

6.  create the database

    ```
    $ mix ecto.create
    ```

7.  generate an API for representing our `Person` resource

    ```
    $ mix phx.gen.json Accounts Person people first_name:string last_name:string username:string email:string
    ```

8. add the resource to your api scope in which should look as follows after the edit:

    `web/router.ex`:

    ```elixir
    scope "/api", ZeroPhoenix do
      pipe_through :api

      resources "/people", PersonController, except: [:new, :edit]
    end
    ```

    Note:  When creating an API, one doesn't require a new or edit actions.  Thus, this is the reason that we are excluding them from this resource.

9.  migrate the database

    ```
    $ mix ecto.migrate
    ```

10.  generate a `Friendship` model which representing our join model:

    ```
    $ mix phx.gen.schema Accounts.Friendship friendships person_id:references:people friend_id:references:people
    ```

11. migrate the database

    ```
    $ mix ecto.migrate
    ```

12.  replace the generated `Person` model with the following:

    `web/models/person.ex`:

    ```elixir
    defmodule ZeroPhoenix.Accounts.Person do
      use Ecto.Schema
      import Ecto.Changeset
      alias ZeroPhoenix.Accounts.Person
      alias ZeroPhoenix.Accounts.Friendship

      schema "people" do
        field(:email, :string)
        field(:first_name, :string)
        field(:last_name, :string)
        field(:username, :string)

        has_many(:friendships, Friendship)
        has_many(:friends, through: [:friendships, :friend])

        timestamps()
      end

      @doc false
      def changeset(%Person{} = person, attrs) do
        person
        |> cast(attrs, [:first_name, :last_name, :username, :email])
        |> validate_required([:first_name, :last_name, :username, :email])
      end
    end
    ```

13. replace the generated `Friendship` model with the following:

    `web/models/friendship.ex`:

    ```elixir
    defmodule ZeroPhoenix.Accounts.Friendship do
      use Ecto.Schema
      import Ecto.Changeset
      alias ZeroPhoenix.Accounts.Friendship

      @required_fields [:person_id, :friend_id]

      schema "friendships" do
        field(:person_id, :id)
        field(:friend_id, :id)

        belongs_to(:person, ZeroPhoenix.Person)
        belongs_to(:friend, ZeroPhoenix.Person)

        timestamps()
      end

      @doc false
      def changeset(%Friendship{} = friendship, attrs) do
        friendship
        |> cast(attrs, @required_fields)
        |> validate_required(@required_fields)
      end
    end
    ```

    Note:  We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` model.

14. create the seeds file

    `priv/repo/seeds.exs`:

    ```
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
    ```

13. seed the database

    ```
    $ mix run priv/repo/seeds.exs
    ```

14. add `absinthe_plug` package to your `mix.exs` dependencies as follows:

    ```elixir
    defp deps do
      [
        {:phoenix, "~> 1.3.0"},
        {:phoenix_pubsub, "~> 1.0"},
        {:phoenix_ecto, "~> 3.2"},
        {:postgrex, ">= 0.0.0"},
        {:phoenix_html, "~> 2.10"},
        {:phoenix_live_reload, "~> 1.0", only: :dev},
        {:gettext, "~> 0.11"},
        {:cowboy, "~> 1.0"},
        {:absinthe_plug, "~> 1.3"}
      ]
    end
    ```

16. update our projects dependencies:

    ```
    $ mix deps.get
    ```

17. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `lib/zero_phoenix_web/graphql/schema.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.Graphql.Schema do
      use Absinthe.Schema

      import_types(ZeroPhoenixWeb.Graphql.Types.Person)

      alias ZeroPhoenix.Repo
      alias ZeroPhoenix.Accounts.Person

      query do
        field :person, type: :person do
          arg(:id, non_null(:id))

          resolve(fn %{id: id}, _info ->
            case Person |> Repo.get(id) do
              nil -> {:error, "Person id #{id} not found"}
              person -> {:ok, person}
            end
          end)
        end
      end
    end
    ```

18. add our Person type which will be performing queries against:

    `lib/zero_phoenix_web/graphql/types/person.ex`:

    ```elixir
    defmodule ZeroPhoenixWeb.Graphql.Types.Person do
      use Absinthe.Schema.Notation

      import Ecto

      alias ZeroPhoenix.Repo

      @desc "a person"
      object :person do
        @desc "unique identifier for the person"
        field :id, non_null(:string)

        @desc "first name of a person"
        field :first_name, non_null(:string)

        @desc "last name of a person"
        field :last_name, non_null(:string)

        @desc "username of a person"
        field :username, non_null(:string)

        @desc "email of a person"
        field :email, non_null(:string)

        @desc "a list of friends for our person"
        field :friends, list_of(:person) do
          resolve fn _, %{source: person} ->
            {:ok, Repo.all(assoc(person, :friends))}
          end
        end
      end
    end
    ```

19. add route for mounting the GraphiQL browser endpoint:

    ```
    scope "/graphiql" do
      pipe_through :api

      forward "/", Absinthe.Plug.GraphiQL, schema: ZeroPhoenix.Graphql.Schema, interface: :simple
    end
    ```

20. start the server

    ```
    $ mix phx.server
    ```

21. navigate to our application within the browser

    ```
    $ open http://localhost:4000/graphiql
    ```

22. enter and run GraphQL query

    ```
    {
      person(id: "1") {
        firstName
        lastName
        username
        email
        friends {
          firstName
          lastName
          username
          email
        }
      }
    }
    ```

    Note:  The GraphQL query is responding with same response but different shape
           within the GraphiQL browser because Elixir Maps perform no ordering on insertion.

## Production Setup

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Phoenix References

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## GraphQL References

  * Official Website: http://graphql.org
  * Absinthe GraphQL Elixir: http://absinthe-graphql.org

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

* [File Bug Reports and Features](https://github.com/steveluscher/zero-to-graphql/issues)

## License

ZeroPhoenix is released under the [MIT license](https://mit-license.org).

## Copyright

copyright:: (c) Copyright 2016 - 2018 Conrad Taylor. All Rights Reserved.
