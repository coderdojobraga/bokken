defmodule BokkenWeb.EnrollmentControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  alias Bokken.Accounts
  alias Bokken.Events

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
      role: "guardian",
      active: true
    }
  end

  def valid_admin do
    %{
      email: "admin@gmail.com",
      password: "administrator123",
      role: "organizer",
      active: true
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

  def admin_attrs do
    user = valid_admin()

    {:ok, new_user} = Accounts.create_user(user)

    @valid_attrs
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  setup %{conn: conn} do
    guardian_attrs = attrs()

    {:ok, guardian_user} =
      Accounts.authenticate_user(guardian_attrs.email, guardian_attrs.password)

    {:ok, guardian} = Accounts.create_guardian(guardian_attrs)

    ninja_attrs = %{
      first_name: "Joana",
      last_name: "Costa",
      birthday: ~U[2007-03-14 00:00:00.000Z]
    }

    user_ninja = %{
      email: "joanacosta@gmail.com",
      password: "ninja123",
      role: "ninja"
    }

    location_attrs = %{
      address: "Test address",
      name: "Departamento de Informática"
    }

    team_attrs = %{
      name: "Turma Yin",
      description: "Uma turma"
    }

    new_user_ninja = Accounts.create_user(user_ninja)

    ninja_fixture =
      ninja_attrs
      |> Map.put(:user_id, elem(new_user_ninja, 1).id)
      |> Map.put(:guardian_id, guardian.id)

    {:ok, ninja} = Accounts.create_ninja(ninja_fixture)

    {:ok, location} = Events.create_location(location_attrs)

    {:ok, team} = Events.create_team(team_attrs)

    event_fixture =
      params_for(:event)
      |> Map.put(:location_id, location.id)
      |> Map.put(:team_id, team.id)

    {:ok, event} = Events.create_event(event_fixture)

    {:ok, conn: log_in_user(conn, guardian_user), ninja: ninja, event: event}
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
      ninja_attrs = %{
        first_name: "Rafaela",
        last_name: "Costa",
        birthday: ~U[2007-03-14 00:00:00.000Z]
      }

      user_ninja = %{
        email: "rafaelacosta@gmail.com",
        password: "ninja123",
        role: "ninja",
        active: true
      }

      user_guardian = %{
        email: "anamaria5@gmail.com",
        password: "guardian123",
        role: "guardian",
        active: true
      }

      new_guardian_attrs = %{
        first_name: "Ana",
        last_name: "Maria",
        mobile: "+351912345678"
      }

      new_user_ninja = Accounts.create_user(user_ninja)
      new_user_guardian = Accounts.create_user(user_guardian)

      new_guardian_attrs =
        new_guardian_attrs
        |> Map.put(:user_id, elem(new_user_guardian, 1).id)

      {:ok, new_guardian} = Accounts.create_guardian(new_guardian_attrs)

      ninja_fixture =
        ninja_attrs
        |> Map.put(:user_id, elem(new_user_ninja, 1).id)
        |> Map.put(:guardian_id, new_guardian.id)

      {:ok, new_ninja} = Accounts.create_ninja(ninja_fixture)

      enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: new_ninja.id, accepted: true}
      }

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert not is_nil(json_response(conn, 403)["reason"])
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
      assert not is_nil(json_response(conn, 404)["reason"])
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
      {:ok, enrollment} = Events.create_enrollment(event, enrollment_attrs)

      new_enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true, id: enrollment.id}
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
