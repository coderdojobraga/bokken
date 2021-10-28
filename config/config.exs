# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bokken,
  ecto_repos: [Bokken.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :bokken, BokkenWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BokkenWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Bokken.PubSub,
  live_view: [signing_salt: "HwkWYgOC"],
  allowed_origins: ~r{https?://(.)*},
  frontend_url: "http://localhost:3000"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :bokken, Bokken.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :bokken, BokkenWeb.Gettext, default_locale: "pt", locales: ~w(en pt)

config :waffle,
  storage: Waffle.Storage.Local,
  asset_host: {:system, "HOST_URL"}

config :kaffy,
  otp_app: :bokken,
  admin_title: "CoderDojo Braga",
  admin_logo: "/images/logo-lettering.png",
  admin_logo_mini: "/images/logo.svg",
  ecto_repo: Bokken.Repo,
  router: BokkenWeb.Router

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
