defmodule BokkenWeb.EnrollmentControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  alias Bokken.Events

  setup %{conn: conn} do
    event = insert(:event)
    guardian_user = insert(:user, role: "guardian")
    guardian = insert(:guardian, user: guardian_user)
    ninja = insert(:ninja, guardian: guardian)

    {:ok, conn: log_in_user(conn, guardian_user), ninja: ninja, event: event}
  end

  describe "show enrollment" do
    test "renders enrollment when data is valid", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]


      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, enrollment_id))
      assert json_response(conn, 200)
    end

    test "fails when enrollment_id is invalid", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => _enrollment_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, Ecto.UUID.generate()))
      assert json_response(conn, 404)
    end
  end

  describe "create enrollment" do
    test "renders enrollment when data is valid", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, enrollment_id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :index, event.id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :index, ninja.id))
      assert json_response(conn, 200)["data"]
    end

    test "fails when enrollment is accepted", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert json_response(conn, 422)
    end

    test "fails when user is not the ninja's guardian", %{
      conn: conn,
      ninja: _ninja,
      event: event
    } do
      new_guardian = insert(:guardian)
      new_ninja = insert(:ninja, guardian: new_guardian)

      enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: new_ninja.id, accepted: true}
      }

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert json_response(conn, 403)
    end
  end

  describe "create enrollment when is not guardian" do
    setup [:login_as_organizer]

    test "fails", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true}}

      assert_raise Phoenix.ActionClauseError, ~r/(?s).*/, fn ->
        post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      end
    end
  end

  describe "delete enrollment" do
    test "deletes enrollment when guardian of the ninja", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.event_enrollment_path(conn, :delete, event.id, enrollment_id))
      assert json_response(conn, 200)["message"]

      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, enrollment_id))
      assert json_response(conn, 404)
    end

    test "fails to delete enrollment when is not ninja's guardian", %{
      conn: conn,
      ninja: _ninja,
      event: event
    } do
      new_ninja = insert(:ninja)

      enrollment_attrs = %{event_id: event.id, ninja_id: new_ninja.id, accepted: false}

      {:ok, enrollment} = Events.create_enrollment(event, :admin, enrollment_attrs)

      conn = delete(conn, Routes.event_enrollment_path(conn, :delete, event.id, enrollment.id))
      assert json_response(conn, 403)
    end
  end

  describe "update enrollment" do
    test "fails when user is not an organizer", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}
      }

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      enrollment = Events.get_enrollment(enrollment_id, [:ninja, :event])

      new_enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true, id: enrollment.id}
      }

      assert_raise Phoenix.ActionClauseError, ~r/(?s).*/, fn ->
        patch(
          conn,
          Routes.event_enrollment_path(conn, :update, event.id, enrollment.id),
          new_enrollment_attrs
        )
      end
    end
  end

  describe "as admin" do
    setup [:login_as_organizer]

    test "updates enrollment when valid data is received and user is admin", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{event_id: event.id, ninja_id: ninja.id, accepted: false}
      {:ok, enrollment} = Events.create_enrollment(event, :admin, enrollment_attrs)

      new_enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true, id: enrollment.id}
      }

      conn =
        patch(
          conn,
          Routes.event_enrollment_path(conn, :update, event.id, enrollment.id),
          new_enrollment_attrs
        )

      assert json_response(conn, 200)
    end
  end
end
