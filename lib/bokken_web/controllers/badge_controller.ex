defmodule BokkenWeb.BadgeController do
  use BokkenWeb, :controller

  alias Bokken.Gamification
  alias Bokken.Gamification.Badge
  alias Bokken.Gamification.BadgeNinja

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) when is_map_key(params, :ninja_id) do
    badges = Gamification.list_badges(params)
    render(conn, "index.json", badges: badges)
  end

  def index(conn, _params) when is_ninja(conn) do
    ninja_id = conn.assigns.current_user.ninja.id
    badges = Gamification.list_badges(%{"ninja_id" => ninja_id})
    render(conn, "index.json", badges: badges)
  end

  def index(conn, _params) when is_mentor(conn) do
    badges = Gamification.list_badges()
    render(conn, "index.json", badges: badges)
  end

  def create(conn, %{"badge_id" => badge_id, "ninja_id" => ninja_id})
      when is_mentor(conn) do
    with {:ok, %BadgeNinja{} = badge_ninja} <- Gamification.give_badge(badge_id, ninja_id) do
      badge = Gamification.get_badge!(badge_ninja.badge_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.badge_path(conn, :show, badge))
      |> render("show.json", badge: badge)
    end
  end

  def create(conn, %{"badge" => badge_params} = params) when not is_map_key(params, :ninja_id) do
    with {:ok, %Badge{} = badge} <- Gamification.create_badge(badge_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.badge_path(conn, :show, badge))
      |> render("show.json", badge: badge)
    end
  end

  def show(conn, %{"id" => id} = params) when not is_map_key(params, :ninja_id) do
    badge = Gamification.get_badge!(id)
    render(conn, "show.json", badge: badge)
  end

  def update(conn, %{"id" => id, "badge" => badge_params}) do
    badge = Gamification.get_badge!(id)

    with {:ok, %Badge{} = badge} <- Gamification.update_badge(badge, badge_params) do
      render(conn, "show.json", badge: badge)
    end
  end

  def delete(conn, %{"id" => badge_id, "ninja_id" => ninja_id}) when is_mentor(conn) do
    with {_n, nil} <- Gamification.remove_badge(badge_id, ninja_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params) when not is_map_key(params, :ninja_id) do
    badge = Gamification.get_badge!(id)

    with {:ok, %Badge{}} <- Gamification.delete_badge(badge) do
      send_resp(conn, :no_content, "")
    end
  end
end
