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
config :zero_phoenix, ZeroPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nvgjFfsHcYw2DWvEX4Rtzj4DONDO4t7+lt4alSLGPFhP58bvBoz7xVv36Co96Yl9",
  render_errors: [view: ZeroPhoenixWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ZeroPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
