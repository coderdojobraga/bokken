defmodule BokkenWeb.AvailabilityControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Events

  setup %{conn: conn} do
    {:ok, location} =
      %{
        address: "Test address",
        name: "Departamento de Informática"
      }
      |> Events.create_location()

    {:ok, team} =
      %{
        name: "Turma Yin",
        description: "Uma turma"
      }
      |> Events.create_team()

    event_fixture =
      %{
        title: "Test event",
        spots_available: 30,
        start_time: ~U[2023-02-14 10:00:00.000Z],
        end_time: ~U[2023-02-14 12:30:00.000Z],
        enrollments_open: ~U[2022-07-03 12:30:00.0Z],
        enrollments_close: ~U[2023-02-13 12:30:00.0Z],
        online: false,
        notes: "Valentines"
      }
      |> Map.put(:location_id, location.id)
      |> Map.put(:team_id, team.id)

    {:ok, event} = Events.create_event(event_fixture)

    {:ok, conn: put_resp_header(conn, "accept", "application/json"), event: event}
  end

  describe "index" do
    setup [:register_and_log_in_mentor]

    test "list all availabilities", %{conn: conn, event: event} do
      conn = get(conn, Routes.event_availability_path(conn, :index, event.id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create availability" do
    setup [:register_and_log_in_mentor]

    test "render availability when data is valid", %{conn: conn, event: event, user: user} do
      availability_attrs = %{
        availability: %{event_id: event.id, mentor_id: user.mentor.id, is_available?: true}
      }

      conn =
        post(conn, Routes.event_availability_path(conn, :create, event.id), availability_attrs)

      assert %{"id" => availability_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :show, event.id, availability_id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :index, event.id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :index, user.mentor.id))
      assert json_response(conn, 200)["data"]
    end
  end
end
