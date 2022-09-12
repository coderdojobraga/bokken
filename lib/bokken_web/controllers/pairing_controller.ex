defmodule BokkenWeb.PairingController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Pairings

  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer

  def index(conn, %{"event_id" => event_id}) when is_organizer(conn) do
    lectures = Events.get_lectures_from_event(event_id)

    conn
    |> put_status(:ok)
    |> render("index.json", lectures: lectures)
  end

  def create(conn, %{"event_id" => event_id}) when is_organizer(conn) do
    lectures = Pairings.create_pairings(event_id)

    conn
    |> put_status(:created)
    |> render("create.json", lectures: lectures)
  end
end
