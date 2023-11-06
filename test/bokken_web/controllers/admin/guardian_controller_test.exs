defmodule BokkenWeb.Admin.GuardianControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  setup %{conn: conn} do
    {:ok, conn: put_resp_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:login_as_organizer]

    test "lists all guardians", %{conn: conn} do
      conn = get(conn, ~p"/api/admin/guardians/")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    setup [:login_as_organizer]

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
