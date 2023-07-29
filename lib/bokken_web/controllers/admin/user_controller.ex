defmodule BokkenWeb.Admin.UserController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Accounts
  alias Bokken.Accounts.User

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def update(conn, %{"id" => id, "user" => user_params}) when is_organizer(conn) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user_as_admin(user, user_params) do
      render(conn, "user.json", user: user)
    end
  end
end
