defmodule BokkenWeb.OrganizerController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Organizer

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    organizers = Accounts.list_organizers()
    render(conn, :index, organizers: organizers)
  end

  def create(conn, %{"organizer" => organizer_params}) when is_organizer(conn) do
    with {:ok, %Organizer{} = organizer} <- Accounts.create_organizer(organizer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/organizers/#{organizer}")
      |> render(:show, organizer: organizer)
    end
  end

  def show(conn, %{"id" => id}) do
    organizer = Accounts.get_organizer!(id)
    render(conn, :show, organizer: organizer)
  end

  def update(conn, %{"id" => id, "organizer" => organizer_params})
      when is_organizer(conn) do
    organizer = Accounts.get_organizer!(id)

    with {:ok, %Organizer{} = organizer} <- Accounts.update_organizer(organizer, organizer_params) do
      render(conn, :show, organizer: organizer)
    end
  end

  def delete(conn, %{"id" => id}) when is_organizer(conn) do
    organizer = Accounts.get_organizer!(id)

    with {:ok, %Organizer{}} <- Accounts.delete_organizer(organizer) do
      send_resp(conn, :no_content, "")
    end
  end
end