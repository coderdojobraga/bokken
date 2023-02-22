defmodule BokkenWeb.EnrollmentControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Events
  alias BokkenWeb.Authorization

  import Bokken.Factory

  setup %{conn: conn} do
    guardian = insert(:guardian)
    {:ok, guardian_user} = Accounts.authenticate_user(guardian.user.email, "password1234!")

    location = insert(:location)

    team = insert(:team)

    {:ok, jwt, _claims} =
      Authorization.encode_and_sign(guardian_user, %{
        role: guardian_user.role,
        active: guardian_user.active
      })

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("user_id", "#{guardian.user_id}")

    ninja = insert(:ninja, %{guardian: guardian})
    event = insert(:event, %{location: location, team: team})

    {:ok, conn: conn, ninja: ninja, event: event}
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
      assert not is_nil(json_response(conn, 403)["reason"])
    end

    test "fails when user is not the ninja's guardian", %{
      conn: conn,
      ninja: _ninja,
      event: event
    } do
      new_user_ninja = insert(:user, %{active: true, role: "ninja"})

      new_user_guardian = insert(:user, %{active: true, role: "guardian"})

      new_guardian = insert(:guardian, %{user: new_user_guardian})

      new_ninja = insert(:ninja, %{guardian: new_guardian, user: new_user_ninja})

      enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: new_ninja.id, accepted: true}
      }

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert not is_nil(json_response(conn, 403)["reason"])
    end

    test "fails when user is not a guardian", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      role = Enum.random(["organizer", "mentor", "ninja"])
      admin_user = insert(:user, %{active: true, role: role})

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(admin_user, %{
          role: admin_user.role,
          active: admin_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{admin_user.id}")

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
      assert not is_nil(json_response(conn, 404)["reason"])
    end
  end

  describe "update enrollment" do
    test "fails when user is not an organizer", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      enrollment = Events.get_enrollment(enrollment_id, [:ninja, :event])

      new_enrollment_attrs = %{
        enrollment: %{accepted: true, id: enrollment.id}
      }

      assert_raise Phoenix.ActionClauseError, fn ->
        patch(
          conn,
          Routes.event_enrollment_path(conn, :update, event.id, enrollment.id),
          new_enrollment_attrs
        )
      end
    end

    test "updates enrollment when valid data is received and user is admin", %{
      conn: conn,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{event: event, ninja: ninja, accepted: false}
      enrollment = insert(:enrollment, enrollment_attrs)

      admin_user = insert(:user, %{role: "organizer"})

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(admin_user, %{
          role: admin_user.role,
          active: admin_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{admin_user.id}")

      new_enrollment_attrs = %{
        enrollment: %{accepted: true, id: enrollment.id}
      }

      conn =
        patch(
          conn,
          Routes.event_enrollment_path(conn, :update, event.id, enrollment.id),
          new_enrollment_attrs
        )

      assert json_response(conn, 200)["data"]
    end
  end
end
