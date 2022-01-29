defmodule BokkenWeb.PageController do
  use BokkenWeb, :controller

  @name Mix.Project.config()[:name]
  @description Mix.Project.config()[:description]
  @version Mix.Project.config()[:version]
  @source Mix.Project.config()[:homepage_url]

  def index(conn, _params) do
    conn
    |> json(%{name: @name, description: @description, version: @version, source: @source})
  end
end
