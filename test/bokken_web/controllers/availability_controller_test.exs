defmodule BokkenWeb.AvailabilityControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Events

  import Bokken.Factory

  setup %{conn: conn} do
    # {:ok, location} =
    #   %{
    #     address: "Test address",
    #     name: "Departamento de Informática"
    #   }
    #   |> Events.create_location()
    location = insert(:location, %{name: "Departamento de Informática", address: "Test address"})

    # {:ok, team} =
    #   %{
    #     name: "Turma Yin",
    #     description: "Uma turma"
    #   }
    #   |> Events.create_team()
    
    team = insert(:team, %{name: "Turma Yin", description: "Uma turma"})

    # event_fixture =
    #   %{
    #     title: "Test event",
    #     spots_available: 30,
    #     start_time: ~U[2023-02-14 10:00:00.000Z],
    #     end_time: ~U[2023-02-14 12:30:00.000Z],
    #     enrollments_open: ~U[2022-07-03 12:30:00.0Z],
    #     enrollments_close: ~U[2023-02-13 12:30:00.0Z],
    #     online: false,
    #     notes: "Valentines"
    #   }
    #   |> Map.put(:location_id, location.id)
    #   |> Map.put(:team_id, team.id)

    # {:ok, event} = Events.create_event(event_fixture)

    event_attrs = %{
      title: "Test event",
      spots_available: 30,
      start_time: ~U[2023-02-14 10:00:00.000Z],
      end_time: ~U[2023-02-14 12:30:00.000Z],
      enrollments_open: ~U[2022-07-03 12:30:00.0Z],
      enrollments_close: ~U[2023-02-13 12:30:00.0Z],
      online: false,
      notes: "Valentines",
      location_id: location.id,
      team_id: team.id
    }

    event = insert(:event, event_attrs)

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
      valid_availability_attrs = %{
        availability: %{event_id: event.id, mentor_id: user.mentor.id, is_available: true}
      }

      conn =
        post(
          conn,
          Routes.event_availability_path(conn, :create, event.id),
          valid_availability_attrs
        )

      assert %{"availability_id" => availability_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :show, event.id, availability_id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :index, event.id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_availability_path(conn, :index, user.mentor.id))
      assert json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event, user: user} do
      invalid_availability_attrs = %{
        availability: %{event_id: event.id, mentor_id: user.mentor.id, is_available: nil}
      }

      conn =
        post(
          conn,
          Routes.event_availability_path(conn, :create, event.id),
          invalid_availability_attrs
        )

      # assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update availability" do
    setup [:register_and_log_in_mentor]

    test "renders availability when data is valid", %{conn: conn, event: event, user: user} do
      availability_attrs = %{event_id: event.id, mentor_id: user.mentor.id, is_available: false}
      {:ok, availability} = Events.create_availability(event, availability_attrs)
      # availability = insert(:availability, availability_attrs)

      new_availability_attrs = %{
        availability: %{
          event_id: event.id,
          mentor_id: user.mentor.id,
          is_available: true,
          id: availability.id
        }
      }

      conn =
        patch(
          conn,
          Routes.event_availability_path(conn, :update, event.id, availability.id),
          new_availability_attrs
        )

      assert json_response(conn, 200)["data"]
    end

    test "render errors when data is invalid", %{conn: conn, event: event, user: user} do
      availability_attrs = %{event_id: event.id, mentor_id: user.mentor.id, is_available: false}
      # availability = insert(:availability, availability_attrs)
      {:ok, availability} = Events.create_availability(event, availability_attrs)

      invalid_availability_attrs = %{
        availability: %{
          event_id: event.id,
          mentor_id: user.mentor.id,
          is_available: nil,
          id: availability.id
        }
      }

      conn =
        patch(
          conn,
          Routes.event_availability_path(conn, :update, event.id, availability.id),
          invalid_availability_attrs
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
