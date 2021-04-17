defmodule BokkenWeb.NinjaController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja
  alias Bokken.Classes

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    ninjas = Accounts.list_ninjas()
    render(conn, "index.json", ninjas: ninjas)
  end

  def ninjas(conn, %{"team_id" => team_id}) do
    ninjas = Classes.list_team_ninjas(team_id)
    render(conn, "index.json", ninjas: ninjas)
  end

  def create(conn, %{"ninja" => ninja_params}) do
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

  def delete(conn, %{"id" => id}) do
    ninja = Accounts.get_ninja!(id)

    with {:ok, %Ninja{}} <- Accounts.delete_ninja(ninja) do
      send_resp(conn, :no_content, "")
    end
  end
end
