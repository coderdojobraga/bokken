defmodule BokkenWeb.Admin.GuardianControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts

  import Bokken.Factory

  setup %{conn: conn} do
    password = "password1234!"
    guardian_user = insert(:user, role: "organizer", password: password)

    {:ok, user} = Accounts.authenticate_user(guardian_user.email, password)

    {:ok, conn: log_in_user(conn, user)}
  end

  describe "index" do
    test "lists all guardians", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/guardians/")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "shoes", %{conn: conn} do
      guardian = insert(:guardian)

      update_attrs = %{
        mobile: "+351915096743",
        first_name: "Ana Maria",
        last_name: "Silva Costa",
        city: "Guimarães"
      }

      user_params = %{
        user_id: guardian.user_id
      }

      conn =
        put(conn, ~p"/api/admin/guardians/#{guardian.id}", %{
          guardian: update_attrs,
          user: user_params
        })

      assert %{"id" => _id} = json_response(conn, 200)["data"]
    end
  end
end
