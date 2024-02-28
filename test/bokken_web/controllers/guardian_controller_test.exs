defmodule BokkenWeb.GuardianControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts.Guardian

  import Bokken.Factory

  setup %{conn: conn} do
    {:ok, conn: put_resp_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:login_as_guardian]

    test "lists all guardians", %{conn: conn} do
      conn = get(conn, ~p"/api/guardians/")
      assert json_response(conn, 200)["data"] != []
    end
  end

  describe "create guardian" do
    setup [:login_as_guardian]

    test "renders guardian when data is valid", %{conn: conn} do
      new_user = insert(:user, role: "guardian")

      guardian_attrs = %{
        city: "Guimarães",
        mobile: "+351915196743",
        first_name: "Carla Maria",
        last_name: "Silva Costa",
        user_id: new_user.id
      }

      guardian = params_for(:guardian, guardian_attrs)

      conn = post(conn, ~p"/api/guardians/", guardian: guardian)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/guardians/#{id}")

      assert %{
               "id" => _id,
               "first_name" => "Carla Maria",
               "last_name" => "Silva Costa"
             } = json_response(conn, 200)["data"]

      assert not Map.has_key?(json_response(conn, 200)["data"], "city")
      assert not Map.has_key?(json_response(conn, 200)["data"], "mobile")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      guardian = params_for(:guardian, mobile: nil)
      user_id = get_req_header(conn, "user_id")
      user_id = Enum.at(user_id, 0)
      guardian = Map.put(guardian, :user_id, user_id)
      conn = post(conn, ~p"/api/guardians/", guardian: guardian)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update guardian" do
    setup [:login_as_guardian]
    setup [:new_guardian_update]

    test "renders guardian when data is valid", %{
      conn: conn,
      guardian: %Guardian{id: _id} = guardian
    } do
      update_attrs = %{
        mobile: "+351915096743",
        first_name: "Ana Maria",
        last_name: "Silva Costa",
        city: "Guimarães"
      }

      conn = put(conn, ~p"/api/guardians/#{guardian.id}", guardian: update_attrs)

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/guardians/#{id}")

      assert %{
               "first_name" => "Ana Maria",
               "last_name" => "Silva Costa"
             } = json_response(conn, 200)["data"]

      assert not Map.has_key?(json_response(conn, 200)["data"], "mobile")
      assert not Map.has_key?(json_response(conn, 200)["data"], "city")
    end

    test "renders errors when data is invalid", %{conn: conn, guardian: guardian} do
      invalid_attrs = %{mobile: nil}
      conn = put(conn, ~p"/api/guardians/#{guardian.id}", guardian: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete guardian" do
    setup [:login_as_guardian]
    setup [:new_guardian]

    test "deletes chosen guardian", %{conn: conn, guardian: guardian} do
      conn = delete(conn, ~p"/api/guardians/#{guardian.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/guardians/#{guardian.id}")
      end
    end
  end

  defp new_guardian(_) do
    guardian = insert(:guardian)
    %{guardian: guardian}
  end

  defp new_guardian_update(_) do
    guardian = insert(:guardian)
    %{guardian: guardian}
  end
end
