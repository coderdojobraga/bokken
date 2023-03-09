defmodule BokkenWeb.GuardianControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian

  import Bokken.Factory

  setup %{conn: conn} do
    password = "password1234!"
    guardian_user = insert(:user, role: "guardian", password: password)

    {:ok, user} = Accounts.authenticate_user(guardian_user.email, password)

    {:ok, conn: log_in_user(conn, user)}
  end

  describe "index" do
    test "lists all guardians", %{conn: conn} do
      conn = get(conn, Routes.guardian_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create guardian" do
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

      conn = post(conn, Routes.guardian_path(conn, :create), guardian: guardian)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.guardian_path(conn, :show, id))

      assert %{
               "id" => _id,
               "city" => "Guimarães",
               "first_name" => "Carla Maria",
               "last_name" => "Silva Costa",
               "mobile" => "+351915196743"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      guardian = params_for(:guardian, mobile: nil)
      user_id = get_req_header(conn, "user_id")
      user_id = Enum.at(user_id, 0)
      guardian = Map.put(guardian, :user_id, user_id)
      conn = post(conn, Routes.guardian_path(conn, :create), guardian: guardian)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update guardian" do
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

      conn = put(conn, Routes.guardian_path(conn, :update, guardian), guardian: update_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.guardian_path(conn, :show, id))

      assert %{
               "city" => "Guimarães",
               "first_name" => "Ana Maria",
               "last_name" => "Silva Costa",
               "mobile" => "+351915096743"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, guardian: guardian} do
      invalid_attrs = %{mobile: nil}
      conn = put(conn, Routes.guardian_path(conn, :update, guardian), guardian: invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete guardian" do
    setup [:new_guardian]

    test "deletes chosen guardian", %{conn: conn, guardian: guardian} do
      conn = delete(conn, Routes.guardian_path(conn, :delete, guardian))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.guardian_path(conn, :show, guardian))
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
