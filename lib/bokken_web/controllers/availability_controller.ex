defmodule BokkenWeb.AvailabilityController do
  use BokkenWeb, :controller

  alias Bokken.Events
  alias Bokken.Events.Availability

  action_fallback BokkenWeb.FallbackController

  def show(conn, %{"id" => availability_id}) do
    availability = Events.get_availability!(availability_id)

    conn
    |> put_status(:ok)
    |> render("show.json", availability: availability)
  end

  def index(conn, availability_params) do
    availabilities = Events.list_availabilities(availability_params, [:mentor])
    unavailabilities = Events.list_unavailabilities(availability_params, [:mentor])

    conn
    |> put_status(:ok)
    |> render("index.json", availabilities: availabilities, unavailabilities: unavailabilities)
    |> IO.inspect()
  end

  def create(conn, %{
        "availability" =>
          %{"mentor_id" => _mentor_id, "is_available" => _is_available, "event_id" => event_id} =
            availability_params
      })
      when is_mentor(conn) do
    event = Events.get_event!(event_id)

    case Events.create_availability(event, availability_params) do
      {:ok, %Availability{} = availability} ->
        conn
        |> put_status(:created)
        |> put_resp_header(
          "location",
          Routes.event_availability_path(conn, :show, event, availability)
        )
        |> render("show.json", availability: availability)

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", reason: reason)
    end
  end

  def update(conn, %{"availability" => availability_params}) when is_mentor(conn) do
    old_availability = Events.get_availability!(availability_params["id"])

    with {:ok, %Availability{} = new_availability} <-
           Events.update_availability(old_availability, availability_params) do
      conn
      |> put_status(:ok)
      |> render("show.json", availability: new_availability)
    end
  end
end
