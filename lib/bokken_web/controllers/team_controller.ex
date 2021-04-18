defmodule BokkenWeb.TeamController do
  use BokkenWeb, :controller

  alias Bokken.Classes
  alias Bokken.Classes.Team

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    teams = Classes.list_teams(params)
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Classes.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Classes.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Classes.get_team!(id)

    with {:ok, %Team{} = team} <- Classes.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Classes.get_team!(id)

    with {:ok, %Team{}} <- Classes.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
