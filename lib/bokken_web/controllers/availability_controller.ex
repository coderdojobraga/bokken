defmodule BokkenWeb.AvailabilityController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Availability

  action_fallback BokkenWeb.FallbackController

  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor

  def show(conn, %{"id" => availability_id}) do
    availability = Events.get_availability(availability_id)

    if is_nil(availability) do
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "No such availability")
    else
      conn
      |> put_status(:ok)
      |> render("show.json", availability: availability)
    end
  end

  def index(conn, availability_params) do
    availability = Events.list_availability(availability_params)

    conn
    |> put_status(:ok)
    |> render("index.json", availability: availability)
  end

  def create(conn, %{
        "availability" =>
          %{"mentor_id" => _mentor_id, "is_available?" => _is_available?, "event_id" => event_id} =
            availability_params
      })
      when is_mentor(conn) do
    event = Events.get_event!(event_id)

    with {:ok, %Availability{} = availability} <-
           Events.create_availability(event, availability_params) do
      conn
      |> put_status(:created)
      |> render("show.json", availability: availability)
    end
  end

  def update(conn, %{"availability" => availability_params}) when is_mentor(conn) do
    old_availability = Events.get_availability(availability_params["id"])

    with {:ok, %Availability{} = new_availability} <-
           Events.update_availability(old_availability, availability_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", availability: new_availability)
    end
  end
end