defmodule BokkenWeb.Admin.GuardianController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    guardians = Accounts.list_guardians([:user])
    render(conn, "index.json", guardians: guardians)
  end

  def update(conn, %{"id" => id, "guardian" => guardian_params, "user" => user_params})
      when is_organizer(conn) do
    guardian = Accounts.get_guardian!(id, [:user])

    with {:ok, %Guardian{} = guardian} <-
           Accounts.update_guardian_and_user(guardian, guardian_params, user_params) do
      render(conn, "guardian.json", guardian: guardian)
    end
  end
end
