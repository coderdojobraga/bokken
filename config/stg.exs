use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to the previous section and set your `:url` port to 443:
#
#     config :bokken, BokkenWeb.Endpoint,
#       ...
#       url: [host: "example.com", port: 443],
#       https: [
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#         transport_options: [socket_opts: [:inet6]]
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your endpoint, ensuring
# no data is ever sent via http, always redirecting to https:
#
#     config :bokken, BokkenWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.

# We load production configuration and secrets
# from environment variables.

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

config :bokken, BokkenWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4003"),
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

config :bokken, :corsica, origin: ~r{#{frontend_app_url}}
