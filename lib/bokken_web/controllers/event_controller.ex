defmodule BokkenWeb.EventController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Event

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor

  def index(conn, params) do
    events = Events.list_events(params)
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id, [:location, :team])
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end
end
