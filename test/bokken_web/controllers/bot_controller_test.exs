defmodule BokkenWeb.BotControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  describe "index" do
    setup [:register_and_log_in_organizer]

    test "list all bots", %{conn: conn} do
      insert(:bot)
      insert(:bot)
      insert(:bot)

      conn = get(conn, Routes.bot_path(conn, :index))
      assert Enum.count(json_response(conn, 200)["data"]) == 3
    end
  end

  describe "show" do
    setup [:register_and_log_in_organizer]

    test "show a bot with the given id", %{conn: conn} do
      bot = insert(:bot)

      conn = get(conn, Routes.bot_path(conn, :show, bot.id))
      %{"name" => name, "id" => id} = json_response(conn, 200)
      assert name == bot.name
      assert id == bot.id
    end
  end

  describe "create" do
    setup [:register_and_log_in_organizer]

    test "create bot", %{conn: conn} do
      name = Faker.StarWars.character()

      conn = post(conn, Routes.bot_path(conn, :create, %{"name" => name}))
      assert %{"api_key" => _api_key} = json_response(conn, 201)
    end
  end

  describe "update" do
    setup [:register_and_log_in_organizer]

    test "update bot", %{conn: conn} do
      bot = insert(:bot)
      name = Faker.StarWars.character()

      conn = patch(conn, Routes.bot_path(conn, :update, bot.id, %{"bot" => %{name: name}}))
      %{"name" => updated_name, "id" => id} = json_response(conn, 200)
      assert name == updated_name
      assert id == bot.id
    end
  end

  describe "delete" do
    setup [:register_and_log_in_organizer]

    test "delete bot", %{conn: conn} do
      bot = insert(:bot)

      conn = delete(conn, Routes.bot_path(conn, :delete, bot.id))
      assert response(conn, 204)
    end
  end
end
