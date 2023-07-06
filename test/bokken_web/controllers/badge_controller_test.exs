defmodule BokkenWeb.BadgeControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.GamificationFixtures
  import Bokken.Factory

  alias Bokken.Gamification.Badge

  @create_attrs %{
    description: "some description",
    name: "some name",
    image: %Plug.Upload{
      content_type: "image/png",
      filename: "badge.png",
      path: "./priv/faker/images/badge.png"
    }
  }
  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    image: %Plug.Upload{
      content_type: "image/png",
      filename: "badge.png",
      path: "./priv/faker/images/badge.png"
    }
  }
  @invalid_attrs %{description: nil, image: nil, name: nil}

  defp create_badge(_) do
    badge = badge_fixture()
    %{badge: badge}
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:login_as_mentor]

    test "lists all badges", %{conn: conn} do
      conn = get(conn, Routes.badge_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all badges of ninja", %{conn: conn} do
      ninja = insert(:ninja)
      %{id: badge_id, description: badge_description, name: badge_name} = badge = insert(:badge)
      badge_ninja = insert(:badge_ninja, badge: badge, ninja: ninja)

      conn = get(conn, Routes.ninja_badge_path(conn, :index, ninja.id))

      assert [
               %{
                 "id" => badge_id,
                 "description" => badge_description,
                 "image" => "/images/default_badge.png",
                 "name" => badge_name
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "create badge" do
    setup [:login_as_mentor]

    test "renders badge when data is valid", %{conn: conn} do
      conn = post(conn, Routes.badge_path(conn, :create), badge: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.badge_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some description",
               "image" => "/uploads/emblems/" <> _rest,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.badge_path(conn, :create), badge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update badge" do
    setup [:create_badge, :login_as_mentor]

    test "renders badge when data is valid", %{conn: conn, badge: %Badge{id: id} = badge} do
      conn = put(conn, Routes.badge_path(conn, :update, badge), badge: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.badge_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "description" => "some updated description",
               "image" => "/uploads/emblems/" <> _rest,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, badge: badge} do
      conn = put(conn, Routes.badge_path(conn, :update, badge), badge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete badge" do
    setup [:create_badge, :login_as_mentor]

    test "deletes chosen badge", %{conn: conn, badge: badge} do
      conn = delete(conn, Routes.badge_path(conn, :delete, badge))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.badge_path(conn, :show, badge))
      end
    end
  end
end
