# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bokken,
  ecto_repos: [Bokken.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :bokken, BokkenWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EbeRKthW2onNBQR46yhrX1D7G4IOQwUZbtrXMwxyrZLkarZm273SX9f35/SRqswg",
  render_errors: [view: BokkenWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Bokken.PubSub,
  live_view: [signing_salt: "HwkWYgOC"],
  allowed_origins: ~r{https?://(.)*},
  frontend_url: "http://localhost:3000"

config :bokken, BokkenWeb.Authorization,
  issuer: "bokken",
  secret_key: "L368R4kzcjSP9bzNrESFzxbysiysnxLwF2BYZgX04PtPC47aRqc4ZGVu2ieAwkeB"

config :bokken, Bokken.Mailer, adapter: Bamboo.LocalAdapter

config :waffle,
  storage: Waffle.Storage.Local,
  asset_host: {:system, "HOST_URL"}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
