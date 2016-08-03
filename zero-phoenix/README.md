# ZeroPhoenix

## Getting Started

## Software requirements

- Elixir 1.3.2 or higher

- Phoenix 1.2.0 or higher

- PostgreSQL 9.5.x or higher

## Quick Installation

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

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

    ```
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

7.  add the resource to your api scope in `web/router.ex` which should look as follows after the edit:

    ```
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

    ```
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

12. add `absinthe` package to your `mix.exs` dependencies as follows:

    ```
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
        {:absinthe, "~> 1.1.0"}
     ]
    end
    ```

13. Add `absinthe` application to your `mix.exs` application as follows:

    ```
    def application do
      [mod: {ZeroPhoenix, []},
       applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext, :phoenix_ecto, :postgrex, :absinthe]]
    end
    ```

14. update our projects dependencies:

    ```
    $ mix deps.get
    ```

## Production Setup

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Phoenix References

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## GraphQL References

  * Official website: http://graphql.org
  * GraphQL in Elixir: http://graphql-elixir.org

## Support

Bug reports and feature requests can be filed with the rest for the Phoenix project here:

* [File Bug Reports and Features](https://github.com/<user-name>/<project-repo>/issues)

## License

ZeroPhoenix is released under the [MIT license](https://mit-license.org).

## Copyright

copyright:: (c) Copyright 2015 Conrad Taylor. All Rights Reserved.
