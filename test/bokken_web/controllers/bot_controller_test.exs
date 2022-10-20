defmodule BokkenWeb.BotControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  # setup %{conn: conn} do
  #   {:ok, conn: put_resp_header(conn, "accept", "application/json")}
  # end

  describe "index" do
    setup [:register_and_log_in_organizer]

    test "list all bots", %{conn: conn} do
      conn = get(conn, Routes.bot_path(conn, :index))
      assert Enum.count(json_response(conn, 201)["data"]) == 3
    end
  end
end
