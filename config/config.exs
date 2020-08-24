# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pool_watch,
  ecto_repos: [PoolWatch.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :pool_watch, PoolWatchWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SXoVMU4qcb9s2y4rMGr8OmQkzRuAWNYpGoOFX6TWYmUM6LQnytZSFCrv1oazc9JG",
  render_errors: [view: PoolWatchWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PoolWatch.PubSub,
  live_view: [signing_salt: "4z0hqMBV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pool_watch, :cardano_endpoint, System.get_env("CARDANO_GQL_URL")

config :pool_watch, PoolWatch.Account.Guardian,
  issuer: "pool_watch",
  secret_key: "OBXQlm9+LZCuDd0fGSCU+jeJ/ZrSzgbtROHOueZJW04qk6yMpQ61/mzF2r4Lkpfn"

config :pool_watch, :twitter, %{
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET")
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
