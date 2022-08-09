defmodule BokkenWeb.PairingController do
  use BokkenWeb, :controller
  
  alias Bokken.Events

  def index(conn, %{"event_id" => event_id}) do
    lectures = Events.get_lectures_from_event(event_id)  

    conn
    |> put_status(:ok)
    |> render("index.json", lectures: lectures)
  end

  # def show(conn, %{"id" => availability_id}) do
  #   availability = Events.get_availability!(availability_id)

  #   conn
  #   |> put_status(:ok)
  #   |> render("show.json", availability: availability)
  # end
  #
  # def show(conn, %{"id" => availability_id}) do
  # availability = Events.get_availability!(availability_id)

  # conn
  # |> put_status(:ok)
  # |> render("show.json", availability: availability)
  # end
end
