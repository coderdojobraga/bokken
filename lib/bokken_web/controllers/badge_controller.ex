defmodule BokkenWeb.BadgeController do
  use BokkenWeb, :controller

  alias Bokken.Gamification
  alias Bokken.Gamification.Badge

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    badges = Gamification.list_badges(params)
    render(conn, "index.json", badges: badges)
  end

  def create(conn, %{"badge" => badge_params}) do
    with {:ok, %Badge{} = badge} <- Gamification.create_badge(badge_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.badge_path(conn, :show, badge))
      |> render("show.json", badge: badge)
    end
  end

  def show(conn, %{"id" => id}) do
    badge = Gamification.get_badge!(id)
    render(conn, "show.json", badge: badge)
  end

  def update(conn, %{"id" => id, "badge" => badge_params}) do
    badge = Gamification.get_badge!(id)

    with {:ok, %Badge{} = badge} <- Gamification.update_badge(badge, badge_params) do
      render(conn, "show.json", badge: badge)
    end
  end

  def delete(conn, %{"id" => id}) do
    badge = Gamification.get_badge!(id)

    with {:ok, %Badge{}} <- Gamification.delete_badge(badge) do
      send_resp(conn, :no_content, "")
    end
  end
end
