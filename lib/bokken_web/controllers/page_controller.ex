defmodule BokkenWeb.PageController do
  use BokkenWeb, :controller
  @name Mix.Project.config()[:app]
  @description Mix.Project.config()[:description]
  @version Mix.Project.config()[:version]

  def index(conn, _params) do
    conn
    |> json(%{name: @name, description: @description, version: @version})
  end
end
