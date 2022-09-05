defmodule BokkenWeb.PairingController do
  use BokkenWeb, :controller
  
  alias Bokken.Events
  alias Bokken.Pairings

  def index(conn, %{"event_id" => event_id}) do
    lectures = Events.get_lectures_from_event(event_id)  

    conn
    |> put_status(:ok)
    |> render("index.json", lectures: lectures)
  end

  def create(conn, %{"event_id" => event_id}) do
    lectures = Pairings.create_pairings(event_id)
    # IO.inspect(Events.get_lectures_from_event(event_id))
    # IO.inspect(lectures)

    conn
    |> put_status(:ok)
    |> render("create.json", lectures: lectures)
  end
end
