defmodule BokkenWeb.NinjaController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja
  alias Bokken.Events.Event
  alias Bokken.Events.Lecture
  alias Bokken.Events.TeamNinja

  action_fallback BokkenWeb.FallbackController

  def index(conn, params)
      when is_map_key(params, "team_id")
      when is_map_key(params, "badge_id")
      when is_map_key(params, "event_id") do
    ninjas = Accounts.list_ninjas()
    render(conn, :index, ninjas: ninjas)
  end

  def index(conn, _params) when is_guardian(conn) or is_organizer(conn) do
    guardian_id = conn.assigns.current_user.guardian.id
    guardian = Accounts.get_guardian!(guardian_id, [:ninjas])
    render(conn, :index, ninjas: guardian.ninjas)
  end

  def create(conn, %{"event_id" => event_id, "ninja_id" => ninja_id})
      when is_guardian(conn) or is_organizer(conn) do
    with {:ok, %Event{} = event, %Lecture{} = _lecture} <-
           Accounts.register_ninja_in_event(event_id, ninja_id) do
      render(conn, :index, ninjas: event.ninjas)
    end
  end

  def create(conn, %{"team_id" => team_id, "ninja_id" => ninja_id})
      when is_guardian(conn) or is_organizer(conn) do
    with {:ok, %TeamNinja{} = team_ninja} <- Accounts.add_ninja_to_team(ninja_id, team_id) do
      ninja = Accounts.get_ninja!(team_ninja.ninja_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team_id}/ninjas/#{ninja}")
      # |> put_resp_header("location" Routes.team_path(conn, :show, ninja))
      |> render(:show, ninja: ninja)
    end
  end

  def create(conn, %{"ninja" => ninja_params} = params)
      when not is_map_key(params, :team_id) and (is_guardian(conn) or is_organizer(conn)) do
    guardian_id = conn.assigns.current_user.guardian.id

    with {:ok, %Ninja{} = ninja} <-
           Accounts.create_ninja(Map.put(ninja_params, "guardian_id", guardian_id)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/ninjas/#{ninja}")
      #  Routes.ninja_path(conn, :show, ninja))
      |> render(:show, ninja: ninja)
    end
  end

  def show(conn, %{"id" => id}) do
    ninja = Accounts.get_ninja!(id, [:skills])
    render(conn, :show, ninja: ninja)
  end

  def show(conn, %{"discord_id" => discord_id}) do
    with {:ok, %Ninja{} = ninja} <- Accounts.get_ninja_by_discord(discord_id) do
      render(conn, :show, ninja: ninja)
    end
  end

  def update(conn, %{"id" => id, "ninja" => ninja_params})
      when is_guardian(conn) or is_organizer(conn) do
    ninja = Accounts.get_ninja!(id)

    with {:ok, %Ninja{} = ninja} <- Accounts.update_ninja(ninja, ninja_params) do
      render(conn, :show, ninja: ninja)
    end
  end

  def update(conn, %{"discord_id" => discord_id, "ninja" => ninja_params}) do
    with {:ok, %Ninja{} = ninja} <- Accounts.get_ninja_by_discord(discord_id),
         {:ok, %Ninja{} = ninja} <- Accounts.update_ninja(ninja, ninja_params) do
      render(conn, :show, ninja: ninja)
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => ninja_id})
      when is_guardian(conn) or is_organizer(conn) do
    with {_n, nil} <- Accounts.remove_ninja_team(team_id, ninja_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params)
      when not is_map_key(params, :team_id) and (is_guardian(conn) or is_organizer(conn)) do
    ninja = Accounts.get_ninja!(id)

    with {:ok, %Ninja{}} <- Accounts.delete_ninja(ninja) do
      send_resp(conn, :no_content, "")
    end
  end
end
