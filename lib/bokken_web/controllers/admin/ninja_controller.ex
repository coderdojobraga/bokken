defmodule BokkenWeb.Admin.NinjaController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    ninjas = Accounts.list_ninjas([:guardian])
    render(conn, "index.json", ninjas: ninjas)
  end

  def update(conn, %{"id" => id, "ninja" => ninja_params}) when is_organizer(conn) do
    ninja = Accounts.get_ninja!(id, [:guardian])

    with {:ok, %Ninja{} = ninja} <- Accounts.update_ninja(ninja, ninja_params) do
      render(conn, "ninja.json", ninja: ninja)
    end
  end
end
