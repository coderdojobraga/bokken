defmodule BokkenWeb.TeamController do
  use BokkenWeb, :controller

  alias Bokken.Classes
  alias Bokken.Classes.{Team, TeamNinja, TeamMentor}

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    teams = Classes.list_teams()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"team_id" => team_id, "ninja_id" => ninja_id} = params)
  when not is_map_key(params, :mentor_id) do
    with {:ok, %TeamNinja{} = team_ninja} <- Classes.add_ninja_to_team(team_id, ninja_id) do
      team = Classes.get_team!(team_ninja.team_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def create(conn, %{"team_id" => team_id, "mentor_id" => mentor_id} = params)
  when not is_map_key(params, :ninja_id) do
    with {:ok, %TeamMentor{} = team_mentor} <- Classes.add_mentor_to_team(team_id, mentor_id) do
      team = Classes.get_team!(team_mentor.team_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, team))
      |> render("show.json", team: team)
    end
  end

  def create(conn, %{"team" => team_params} = params) when
    (not is_map_key(params, :ninja_id) or not is_map_key(params, :mentor_id)) do
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

  def delete(conn, %{"id" => team_id, "ninja_id" => ninja_id} = params) when
    not is_map_key(params, :mentor_id) do
    with {_n, nil} <- Classes.remove_ninja_team(team_id, ninja_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => team_id, "mentor_id" => mentor_id} = params) when
    not is_map_key(params, :ninja_id) do
    with {_n, nil} <- Classes.remove_mentor_team(team_id, mentor_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params) when (not is_map_key(params, :ninja_id) or
  not is_map_key(params, :mentor_id)) do
    team = Classes.get_team!(id)

    with {:ok, %Team{}} <- Classes.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
