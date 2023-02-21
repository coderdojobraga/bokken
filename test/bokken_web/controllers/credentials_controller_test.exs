defmodule BokkenWeb.CredentialsControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Credential
  alias BokkenWeb.Authorization

  import Bokken.Factory

  @valid_attrs %{
    city: "Braga",
    mobile: "+351915096743",
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

  def valid_user do
    %{
      email: "anamaria@gmail.com",
      password: "guardian123",
      role: "guardian",
      active: true
    }
  end

  def attrs do
    user = valid_user()

    {:ok, new_user} = Accounts.create_user(user)

    @valid_attrs
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  @update_attrs %{
    city: "Guimarães",
    mobile: "+351915096743",
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

  setup %{conn: conn} do
    guardian = attrs()
    {:ok, user} = Accounts.authenticate_user(guardian.email, guardian.password)

    {:ok, jwt, _claims} =
      Authorization.encode_and_sign(user, %{role: user.role, active: user.active})

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("user_id", "#{guardian[:user_id]}")

    {:ok, conn: conn}
  end

  describe "show" do
    test "shows credential", %{conn: conn} do
      ninja = insert(:ninja)
      credential = insert(:credential, ninja_id: ninja.id)

      conn =
        conn
        |> get(Routes.credential_path(conn, :show, credential.id))

      assert %{
               "id" => credential.id,
               "ninja_id" => ninja.id
             } == json_response(conn, 200)
    end
  end

  describe "update" do
    test "updates credential (not taken)", %{conn: conn} do
      ninja = insert(:ninja)
      credential = insert(:credential, ninja_id: nil)

      conn =
        conn
        |> put(Routes.credential_path(conn, :update, credential.id), %{
          "credential_id" => credential.id,
          "ninja_id" => ninja.id
        })

      assert %{
               "id" => credential.id,
               "ninja_id" => ninja.id
             } == json_response(conn, 200)
    end

    test "updates credential (taken)", %{conn: conn} do
      ninja = insert(:ninja)
      mentor = insert(:mentor)
      credential = insert(:credential, ninja_id: ninja.id)

      conn =
        conn
        |> put(Routes.credential_path(conn, :update, credential.id), %{
          "credential_id" => credential.id,
          "mentor_id" => mentor.id
        })

      assert json_response(conn, 422)
    end
  end

  describe "delete" do
    test "delete credential (taken)", %{conn: conn} do
      ninja = insert(:ninja)
      credential = insert(:credential, ninja_id: ninja.id)

      conn1 =
        conn
        |> delete(Routes.credential_path(conn, :delete, credential.id))

      assert response(conn1, 204)

      conn2 =
        conn
        |> get(Routes.credential_path(conn, :show, credential.id))

      assert %{
               "id" => credential.id
             } == json_response(conn2, 200)
    end
  end
end
