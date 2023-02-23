import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :argon2_elixir, t_cost: 1, m_cost: 8

# Configure your database
config :bokken, Bokken.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We run a server during test. If one is not required,
# you can disable the server option below.
config :bokken, BokkenWeb.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: String.to_integer(System.get_env("PORT", "4002"))
  ],
  secret_key_base: "UYOacKoTtE8G5zQ4bjnfor+cxMxtRf3wOhpmYHPuMZDgrqtzzwXdt9uMfTb9wsSl",
  server: true

config :bokken, BokkenWeb.Authorization,
  issuer: "bokken",
  secret_key: "3ZMckYtz7b+IbkHna9191NDcZFEGk06QYQBCbGtvfV6rASJ8zxjhvRwBez5CuMV4"

# In test we don't send emails.
config :bokken, Bokken.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
