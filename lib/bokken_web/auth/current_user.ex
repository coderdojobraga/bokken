defmodule BokkenWeb.Auth.CurrentUser do
  @moduledoc false
  alias Bokken.Repo
  alias BokkenWeb.Authorization

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> Plug.Conn.assign(:current_user, get_current_user(conn))
  end

  defp get_current_user(conn) do
    Authorization.Plug.current_resource(conn)
    |> then(&Repo.preload(&1, [&1.role]))
  end
end
