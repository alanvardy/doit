# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :doit,
  ecto_repos: [Doit.Repo]

# Configures the endpoint
config :doit, DoitWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SvFLtAce3Sz5k7Z8/xpA0dU536kYCbJR+WXPJYcTnIbevrxFxkYmT4WloQgJWg+O",
  render_errors: [view: DoitWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Doit.PubSub,
  live_view: [signing_salt: "cgEVrS1E"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
