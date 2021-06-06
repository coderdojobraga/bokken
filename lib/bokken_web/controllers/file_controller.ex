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

  def images(conn, %{"type" => type, "id" => id, "file" => image}) do
    send_file(conn, 200, "uploads/#{type}/#{id}/#{image}")
  end
end
