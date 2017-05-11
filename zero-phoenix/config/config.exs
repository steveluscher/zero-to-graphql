# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :zero_phoenix,
  ecto_repos: [ZeroPhoenix.Repo]

# Configures the endpoint
config :zero_phoenix, ZeroPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bS5peykLEJ5cQDZ+u5M+ncgdhOyKND6P/vSLoLKdqaRgGqe1QHuejc5XvfifUUUo",
  render_errors: [view: ZeroPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZeroPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
