defmodule BokkenWeb.TokenControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  describe "index" do
    setup [:login_as_organizer]

    test "list all tokens", %{conn: conn} do
      insert(:token)
      insert(:token)
      insert(:token)

      conn = get(conn, Routes.token_path(conn, :index))
      assert Enum.count(json_response(conn, 200)["data"]) == 3
    end
  end

  describe "show" do
    setup [:login_as_organizer]

    test "show a token with the given id", %{conn: conn} do
      token = insert(:token)

      conn = get(conn, Routes.token_path(conn, :show, token.id))
      %{"name" => name, "id" => id} = json_response(conn, 200)
      assert name == token.name
      assert id == token.id
    end
  end

  describe "create" do
    setup [:login_as_organizer]

    test "create token", %{conn: conn} do
      name = Faker.StarWars.character()
      description = Faker.Lorem.sentence()
      role = "bot"
      attrs = %{"token" => %{name: name, description: description, role: role}}

      conn = post(conn, Routes.token_path(conn, :create, attrs))

      assert %{
               "id" => _id,
               "jwt" => _jwt,
               "description" => _description,
               "role" => _role,
               "created_at" => _created_at
             } = json_response(conn, 201)
    end
  end

  describe "update" do
    setup [:login_as_organizer]

    test "update token", %{conn: conn} do
      token = insert(:token)
      name = Faker.StarWars.character()

      conn = patch(conn, Routes.token_path(conn, :update, token.id, %{"token" => %{name: name}}))
      %{"name" => updated_name, "id" => id} = json_response(conn, 200)
      assert name == updated_name
      assert id == token.id
    end
  end

  describe "delete" do
    setup [:login_as_organizer]

    test "delete token", %{conn: conn} do
      token = insert(:token)

      conn = delete(conn, Routes.token_path(conn, :delete, token.id))
      assert response(conn, 204)
    end
  end
end
