defmodule BokkenWeb.Auth.CurrentUser do
  @moduledoc false
  alias Bokken.Authorization
  alias Bokken.Repo

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.assign(:current_user, get_current_user(conn))
  end

  defp get_current_user(conn) do
    conn
    |> Authorization.Plug.current_resource()
    |> then(&Repo.preload(&1, [&1.role]))
  end
end
