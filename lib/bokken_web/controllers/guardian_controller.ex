defmodule BokkenWeb.GuardianController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian
  import Bokken.Guards

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    guardians = Accounts.list_guardians()
    render(conn, "index.json", guardians: guardians)
  end

  def create(conn, %{"guardian" => guardian_params}) when is_guardian(conn) do
    with {:ok, %Guardian{} = guardian} <- Accounts.create_guardian(guardian_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.guardian_path(conn, :show, guardian))
      |> render("show.json", guardian: guardian)
    end
  end

  def show(conn, %{"id" => id}) do
    guardian = Accounts.get_guardian!(id)
    render(conn, "show.json", guardian: guardian)
  end

  def update(conn, %{"id" => id, "guardian" => guardian_params}) when is_guardian(conn) do
    guardian = Accounts.get_guardian!(id)

    with {:ok, %Guardian{} = guardian} <- Accounts.update_guardian(guardian, guardian_params) do
      render(conn, "show.json", guardian: guardian)
    end
  end

  def delete(conn, %{"id" => id}) when is_guardian(conn) or is_organizer(conn) do
    guardian = Accounts.get_guardian!(id)

    with {:ok, %Guardian{}} <- Accounts.delete_guardian(guardian) do
      send_resp(conn, :no_content, "")
    end
  end
end
