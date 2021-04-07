# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :bokken, Bokken.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :bokken, BokkenWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

secret_key_guardian =
  System.get_env("SECRET_KEY_GUARDIAN") ||
    raise """
    environment variable SECRET_KEY_GUARDIAN is missing.
    You can generate one by calling: mix guardian.gen.secret
    """

config :bokken, BokkenWeb.Authorization,
  issuer: "bokken",
  secret_key: secret_key_guardian,
  ttl: {1, :day}

frontend_app_url =
  System.get_env("FRONTEND_APP_URL") ||
    raise """
    environment variable FRONTEND_APP_URL is missing.
    Setup the URL where your frontend app will run as a regex expression.
    """

config :cors_plug,
  origin: ~r/#{frontend_app_url}/,
  max_age: 86400

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :bokken, BokkenWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
