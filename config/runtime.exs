# In this file, we load production configuration and secrets
# from environment variables.
import Config
import Dotenvy

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
if config_env() in [:dev, :test] do
  source([".env", ".env.#{config_env()}", ".env.#{config_env()}.local"])

  config :bokken, Bokken.Repo,
    username: env!("DB_USERNAME", :string, "postgres"),
    password: env!("DB_PASSWORD", :string, "postgres"),
    database: env!("DB_NAME", :string, "bokken_#{config_env()}"),
    hostname: env!("DB_HOST", :string, "localhost"),
    port: env!("DB_PORT", :integer, 5432)
end

# The block below contains prod specific runtime configuration.
if config_env() in [:prod, :stg] do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: postgres://USER:PASS@HOST:PORT/DATABASE
      """

  config :bokken, Bokken.Repo,
    # ssl: true,
    # socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  frontend_url =
    System.get_env("FRONTEND_URL") ||
      raise """
      environment variable FRONTEND_URL is missing.
      Setup the URL where your frontend app will run.
      """

  config :bokken, BokkenWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT", "4004"))
    ],
    secret_key_base: secret_key_base,
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

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.
  config :bokken, BokkenWeb.Endpoint, server: true
end
