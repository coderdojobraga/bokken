defmodule BokkenWeb.PageController do
  use BokkenWeb, :controller

  @app Mix.Project.config()[:app]
  @version Mix.Project.config()[:version]
  @description Mix.Project.config()[:description]

  def index(conn, _params) do
    conn
    |> json(%{app: @app, version: @version, description: @description})
  end
end
