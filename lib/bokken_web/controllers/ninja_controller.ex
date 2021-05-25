defmodule BokkenWeb.NinjaController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja
  alias Bokken.Events.TeamNinja

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    ninjas = Accounts.list_ninjas(params)
    render(conn, "index.json", ninjas: ninjas)
  end

  def create(conn, %{"team_id" => team_id, "ninja_id" => ninja_id}) do
    with {:ok, %TeamNinja{} = team_ninja} <- Accounts.add_ninja_to_team(team_id, ninja_id) do
      ninja = Accounts.get_ninja!(team_ninja.ninja_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, ninja))
      |> render("show.json", ninja: ninja)
    end
  end

  def create(conn, %{"ninja" => ninja_params} = params) when not is_map_key(params, :team_id) do
    with {:ok, %Ninja{} = ninja} <- Accounts.create_ninja(ninja_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.ninja_path(conn, :show, ninja))
      |> render("show.json", ninja: ninja)
    end
  end

  def show(conn, %{"id" => id}) do
    ninja = Accounts.get_ninja!(id)
    render(conn, "show.json", ninja: ninja)
  end

  def update(conn, %{"id" => id, "ninja" => ninja_params}) do
    ninja = Accounts.get_ninja!(id)

    with {:ok, %Ninja{} = ninja} <- Accounts.update_ninja(ninja, ninja_params) do
      render(conn, "show.json", ninja: ninja)
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => ninja_id}) do
    with {_n, nil} <- Accounts.remove_ninja_team(team_id, ninja_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params) when not is_map_key(params, :team_id) do
    ninja = Accounts.get_ninja!(id)

    with {:ok, %Ninja{}} <- Accounts.delete_ninja(ninja) do
      send_resp(conn, :no_content, "")
    end
  end
end
