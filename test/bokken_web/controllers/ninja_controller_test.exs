defmodule BokkenWeb.NinjaControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Ninja

  @create_attrs %{
    belt: "some belt",
    birthday: ~D[2010-04-17],
    notes: "some notes",
    social: []
  }
  @update_attrs %{
    belt: "some updated belt",
    birthday: ~D[2011-05-18],
    notes: "some updated notes",
    social: []
  }
  @invalid_attrs %{belt: nil, birthday: nil, notes: nil, social: nil}

  def fixture(:ninja) do
    {:ok, ninja} = Accounts.create_ninja(@create_attrs)
    ninja
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ninjas", %{conn: conn} do
      conn = get(conn, Routes.ninja_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create ninja" do
    test "renders ninja when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ninja_path(conn, :create), ninja: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.ninja_path(conn, :show, id))

      assert %{
               "id" => id,
               "belt" => "some belt",
               "birthday" => "2010-04-17",
               "notes" => "some notes",
               "social" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ninja_path(conn, :create), ninja: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update ninja" do
    setup [:create_ninja]

    test "renders ninja when data is valid", %{conn: conn, ninja: %Ninja{id: id} = ninja} do
      conn = put(conn, Routes.ninja_path(conn, :update, ninja), ninja: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.ninja_path(conn, :show, id))

      assert %{
               "id" => id,
               "belt" => "some updated belt",
               "birthday" => "2011-05-18",
               "notes" => "some updated notes",
               "social" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, ninja: ninja} do
      conn = put(conn, Routes.ninja_path(conn, :update, ninja), ninja: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete ninja" do
    setup [:create_ninja]

    test "deletes chosen ninja", %{conn: conn, ninja: ninja} do
      conn = delete(conn, Routes.ninja_path(conn, :delete, ninja))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.ninja_path(conn, :show, ninja))
      end
    end
  end

  defp create_ninja(_) do
    ninja = fixture(:ninja)
    %{ninja: ninja}
  end
end
