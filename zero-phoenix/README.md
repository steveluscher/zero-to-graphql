# ZeroPhoenix

## Getting Started

## Software requirements

- [Elixir 1.3.2 or higher](http://elixir-lang.org/install.html)

- [Phoenix 1.2.0 or higher](http://www.phoenixframework.org/docs/installation)

- PostgreSQL 9.5.x or higher

## Quick Installation

1. clone this repository

   ```
   $ git clone git@github.com:steveluscher/zero-to-graphql.git
   ```

2. change directory location

   ```
   $ cd /path/to/zero-phoenix
   ```

2. install dependencies

   ```
   $ mix deps.get
   ```

3. create, migrate, and seed the database

   ```
   $ mix ecto.create
   $ mix ecto.migrate
   $ mix ecto.seed
   ```

4. start the server

   ```
   $ mix phoenix.server
   ```

5. navigate to our application within the browser

   ```
   open http://localhost:4000/graphiql
   ```

6. enter and run GraphQL query

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
    $ mix phoenix.new zero_phoenix --no-brunch
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

5.  generate an API for representing our `Person` resource

    ```
    $ mix phoenix.gen.json Person people first_name:string last_name:string username:string email:string
    ```

6.   replace the generated `Person` model with the following:

    `web/models/person.rb`:

    ```elixir
    defmodule ZeroPhoenix.Person do
      use ZeroPhoenix.Web, :model

      @required_fields ~w(first_name last_name username email)
      @optional_fields ~w()

      schema "people" do
        field :first_name, :string
        field :last_name, :string
        field :username, :string
        field :email, :string

        has_many :friendships, ZeroPhoenix.Friendship
        has_many :friends, through: [:friendships, :friend]

        timestamps()
      end

      @doc """
      Builds a changeset based on the `struct` and `params`.
      """
      def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:first_name, :last_name, :username, :email])
        |> validate_required([:first_name, :last_name, :username, :email])
      end
    end
    ```

7.  add the resource to your api scope in which should look as follows after the edit:

    `web/router.ex`:

    ```elixir
    scope "/api", ZeroPhoenix do
      pipe_through :api

      resources "/people", PersonController, except: [:new, :edit]
    end
    ```

    Note:  When creating an API, one doesn't require a new or edit actions.  Thus, this is the reason that we are excluding them from this resource.

8.  create and migrate the database

    ```
    $ mix ecto.create
    $ mix ecto.migrate
    ```

9.  generate a `Friendship` model which representing our join model:

    ```
    $ mix phoenix.gen.model Friendship friendships person_id:references:people friend_id:references:people
    ```

10.  replace the generated `Friendship` model with the following:

    `web/models/friendship.rb`:

    ```elixir
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
    ```

    Note:  We want `friend_id` to reference the `people` table because our `friend_id` really represents a `Person` model.

11.  migrate the database

    ```
    $ mix ecto.migrate
    ```

12. add `absinthe_plug` package to your `mix.exs` dependencies as follows:

    ```elixir
    defp deps do
      [
        {:phoenix, "~> 1.2.0"},
        {:phoenix_pubsub, "~> 1.0"},
        {:ecto, github: "elixir-ecto/ecto", override: true },
        {:phoenix_ecto, "~> 3.0"},
        {:postgrex, ">= 0.0.0"},
        {:phoenix_html, "~> 2.6"},
        {:phoenix_live_reload, "~> 1.0", only: :dev},
        {:gettext, "~> 0.11"},
        {:cowboy, "~> 1.0"},
        {:absinthe_plug, "~> 1.1"}
     ]
    end
    ```

13. Add `absinthe_plug` application to your `mix.exs` application as follows:

    ```elixir
    def application do
      [mod: {ZeroPhoenix, []},
       applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto, :postgrex, absinthe_plug]]
    end
    ```

14. update our projects dependencies:

    ```
    $ mix deps.get
    ```

15. add the GraphQL schema which represents our entry point into our GraphQL structure:

    `web/graphql/schema.ex`:

    ```elixir
    defmodule ZeroPhoenix.Graphql.Schema do
      use Absinthe.Schema

      import_types ZeroPhoenix.Graphql.Types.Person

      alias ZeroPhoenix.Repo

      query do
        field :person, type: :person do
          arg :id, non_null(:id)
          resolve fn %{id: id}, _info ->
            case ZeroPhoenix.Person|> Repo.get(id) do
              nil  -> {:error, "Person id #{id} not found"}
              person -> {:ok, person}
            end
          end
        end
      end
    end
    ```

16. add our Person type which will be performing queries against:

    `web/graphql/types/person.ex`:

    ```elixir
    defmodule ZeroPhoenix.Graphql.Types.Person do
      use Absinthe.Schema.Notation

      import Ecto

      alias ZeroPhoenix.Repo
      alias ZeroPhoenix.Friendship

      @desc "a person"
      object :person do
        @desc "unique identifier for the person"
        field :id, :string

        @desc "first name of a person"
        field :first_name, :string

        @desc "last name of a person"
        field :last_name, :string

        @desc "username of a person"
        field :username, :string

        @desc "email of a person"
        field :email, :string

        @desc "a list of friends for our person"
        field :friends, list_of(:person) do
          resolve fn _, %{source: person} ->
            {:ok, Repo.all(assoc(person, :friends))}
          end
        end
      end
    end
    ```

17. add route for mounting the GraphiQL browser endpoint:

    ```
    scope "/graphiql" do
      pipe_through :api

      forward "/", Absinthe.Plug.GraphiQL, schema: ZeroPhoenix.Graphql.Schema
    end
    ```

18. start the server

    ```
    $ mix phoenix.server
    ```

19. navigate to our application within the browser

    ```
    open http://localhost:4000/graphiql
    ```

20. enter and run GraphQL query

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

* [File Bug Reports and Features](https://github.com/<user-name>/<project-repo>/issues)

## License

ZeroPhoenix is released under the [MIT license](https://mit-license.org).

## Copyright

copyright:: (c) Copyright 2015 Conrad Taylor. All Rights Reserved.
