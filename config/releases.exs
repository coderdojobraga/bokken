# In this file, we load production configuration and secrets
# from environment variables.
import Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: postgres://USER:PASS@HOST:PORT/DATABASE
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

allowed_origins =
  System.get_env("ALLOWED_ORIGINS") ||
    raise """
    environment variable ALLOWED_ORIGINS is missing.
    Setup the URL where your frontend app will run as a regex expression.
    """

frontend_url =
  System.get_env("FRONTEND_URL") ||
    raise """
    environment variable FRONTEND_URL is missing.
    Setup the URL where your frontend app will run.
    """

config :bokken, BokkenWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4001"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  allowed_origins: ~r{#{allowed_origins}},
  frontend_url: frontend_url

secret_key_guardian =
  System.get_env("SECRET_KEY_GUARDIAN") ||
    raise("""
    environment variable SECRET_KEY_GUARDIAN is missing.
    You can generate one by calling: mix guardian.gen.secret
    """)

config :bokken, BokkenWeb.Authorization,
  issuer: "bokken",
  secret_key: secret_key_guardian,
  ttl: {1, :day}

host_url =
  System.get_env("HOST_URL") ||
    raise """
    environment variable HOST_URL is missing.
    Setup the URL where you are hosting the server.
    """

config :waffle,
  storage: Waffle.Storage.Local,
  asset_host: host_url

# ## Using releases (Elixir v1.9+)
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
config :bokken, BokkenWeb.Endpoint, server: true
