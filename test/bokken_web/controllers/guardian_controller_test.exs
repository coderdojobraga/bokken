defmodule BokkenWeb.GuardianControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian
  alias BokkenWeb.Authorization

  @invalid_attrs %{
    city: "Braga",
    mobile: nil,
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

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
      role: "guardian"
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

  describe "index" do
    test "lists all guardians", %{conn: conn} do
      conn = get(conn, Routes.guardian_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create guardian" do
    test "renders guardian when data is valid", %{conn: conn} do
      guardian = %{
        city: "Guimarães",
        mobile: "+351915196743",
        first_name: "Carla Maria",
        last_name: "Silva Costa"
      }

      user = %{
        email: "carlacosta@gmail.com",
        password: "guardian123",
        role: "guardian"
      }

      new_user = Accounts.create_user(user)
      guardian = Map.put(guardian, :user_id, elem(new_user, 1).id)
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
      guardian = @invalid_attrs
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
      conn = put(conn, Routes.guardian_path(conn, :update, guardian), guardian: @update_attrs)
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
      conn = put(conn, Routes.guardian_path(conn, :update, guardian), guardian: @invalid_attrs)
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
    guardian = %{
      city: "Braga",
      mobile: "+351915026743",
      first_name: "Ana",
      last_name: "Silva Costa"
    }

    user = %{
      email: "ana@gmail.com",
      password: "guardian123",
      role: "guardian"
    }

    new_user = Accounts.create_user(user)
    attrs = Map.put(guardian, :user_id, elem(new_user, 1).id)

    {:ok, guardian} = Accounts.create_guardian(attrs)

    %{guardian: guardian}
  end

  defp new_guardian_update(_) do
    guardian = %{
      city: "Braga",
      mobile: "+351915426743",
      first_name: "Catarina Anabela",
      last_name: "Silva Costa"
    }

    user = %{
      email: "catarinasilvacosta@gmail.com",
      password: "guardian123",
      role: "guardian"
    }

    new_user = Accounts.create_user(user)
    attrs = Map.put(guardian, :user_id, elem(new_user, 1).id)

    {:ok, guardian} = Accounts.create_guardian(attrs)

    %{guardian: guardian}
  end
end
