defmodule BokkenWeb.LocationController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Events
  alias Bokken.Events.Location

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    locations = Events.list_locations()
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"location" => location_params}) when is_organizer(conn) do
    with {:ok, %Location{} = location} <- Events.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Events.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) when is_organizer(conn) do
    location = Events.get_location!(id)

    with {:ok, %Location{} = location} <- Events.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) when is_organizer(conn) do
    location = Events.get_location!(id)

    with {:ok, %Location{}} <- Events.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
