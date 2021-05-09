defmodule BokkenWeb.FileController do
  use BokkenWeb, :controller

  action_fallback BokkenWeb.FallbackController

  def humans_txt(conn, _params) do
    if Browser.known?(conn) do
      send_file(conn, 200, "priv/static/humans.html")
    else
      send_file(conn, 200, "priv/static/humans.txt")
    end
  end

  def avatars(conn, %{"user_id" => user_id, "file" => avatar}) do
    send_file(conn, 200, "uploads/avatars/#{user_id}/#{avatar}")
  end
end
