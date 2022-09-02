defmodule BokkenWeb.Auth.ActiveUser do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user.active do
      conn
    else
      conn
      |> send_resp(:forbidden, "")
      |> halt()
    end
  end
end
