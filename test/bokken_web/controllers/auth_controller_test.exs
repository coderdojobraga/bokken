defmodule BokkenWeb.AuthControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    test "sign_up new user when data is valid", %{conn: conn} do
      user_params = params_for(:user)

      conn = post(conn, ~p"/api/auth/sign_up", user_params)

      assert json_response(conn, 201)
    end

    test "sign_up new user when data is invalid", %{conn: conn} do
      user_params = params_for(:user, %{role: "random"})

      conn = post(conn, ~p"/api/auth/sign_up", user_params)

      assert json_response(conn, 422) == %{"errors" => %{"role" => ["não é válido"]}}
    end
  end

  describe "sign_in" do
    test "sign_in user when data is valid", %{conn: conn} do
      user = insert(:user)

      conn = post(conn, ~p"/api/auth/sign_in", %{email: user.email, password: user.password})

      assert json_response(conn, 200)
    end

    test "sign_in user when data is invalid", %{conn: conn} do
      user = insert(:user)

      conn = post(conn, ~p"/api/auth/sign_in", %{email: user.email, password: "random1234"})

      assert json_response(conn, 404) == %{"errors" => %{"detail" => "Not Found"}}
    end
  end

  describe "show" do
    test "shows current user when logged in", %{conn: conn} do
      user = insert(:user)

      conn = post(conn, ~p"/api/auth/sign_in", %{email: user.email, password: user.password})
      conn = get(conn, ~p"/api/auth/me")

      assert json_response(conn, 200)
    end

    test "throws error when not logged in", %{conn: conn} do
      conn = get(conn, ~p"/api/auth/me")

      assert json_response(conn, 401) == %{"error" => "unauthenticated"}
    end
  end

  describe "sign_out" do
    setup [:login_as_guardian]

    test "sign_out user", %{conn: conn} do
      insert(:user)

      conn =
        delete(conn, ~p"/api/auth/sign_out")
        |> get(~p"/api/auth/me")

      assert json_response(conn, 401) == %{"error" => "unauthenticated"}
    end
  end

  describe "update" do
    setup [:login_as_guardian]

    test "update new user", %{conn: conn} do
      user_params = %{
        email: "random@gmail.com"
      }

      conn = put(conn, ~p"/api/auth/me", user: user_params)

      assert json_response(conn, 200)["verified"] == false
    end
  end

  describe "create" do
    setup [:login_as_guardian]

    test "create new guardian", %{conn: conn} do
      params = params_for(:guardian)

      conn = post(conn, ~p"/api/auth/me", user: params)

      assert json_response(conn, 201)
    end

    test "create new ninja account", %{conn: conn} do
      user = conn.private.guardian_default_resource
      ninja = insert(:ninja, %{guardian: user.guardian})

      params = %{
        first_name: "Daniel",
        last_name: "Pereira",
        email: "ninja@gmail.com",
        mobile: "929 066 896"
      }

      conn = post(conn, ~p"/api/auth/me", %{ninja_id: ninja.id, user: params})

      assert json_response(conn, 201)
    end
  end
end
