defmodule BokkenWeb.Auth.ActiveUser do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns.current_user.active do
      conn
    else
      body =
        Jason.encode!(%{
          errors: %{
            user: "user is not active"
          }
        })

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(403, body)
      |> halt()
    end
  end
end
