import Config

# Configure your database
config :bokken, Bokken.Repo,
  username: System.get_env("DB_USERNAME", "postgres"),
  password: System.get_env("DB_PASSWORD", "postgres"),
  database: System.get_env("DB_NAME", "bokken_dev"),
  hostname: System.get_env("DB_HOST", "localhost"),
  port: System.get_env("DB_PORT", "5432"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :bokken, BokkenWeb.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: String.to_integer(System.get_env("PORT") || "4000")
  ],
  check_origin: false,
  debug_errors: true,
  code_reloader: true,
  watchers: [],
  secret_key_base: "EbeRKthW2onNBQR46yhrX1D7G4IOQwUZbtrXMwxyrZLkarZm273SX9f35SRqswg",
  frontend_url: System.get_env("FRONTEND_URL", "http://localhost:3000")

config :bokken, BokkenWeb.Authorization,
  issuer: "bokken",
  secret_key: "L368R4kzcjSP9bzNrESFzxbysiysnxLwF2BYZgX04PtPC47aRqc4ZGVu2ieAwkeB"

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
