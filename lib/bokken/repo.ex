defmodule Bokken.Repo do
  use Ecto.Repo,
    otp_app: :bokken,
    adapter: Ecto.Adapters.Postgres
end
