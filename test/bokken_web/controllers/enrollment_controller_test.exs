defmodule BokkenWeb.EnrollmentControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.Guardian
  alias Bokken.Events
  alias BokkenWeb.Authorization

  @invalid_attrs %{
    city: "Braga",
    mobile: nil,
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

  @valid_attrs %{
    city: "Braga",
    mobile: "915096743",
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

  def valid_user do
    %{
      email: "anamaria@gmail.com",
      password: "guardian123",
      role: "guardian"
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

  @update_attrs %{
    city: "Guimarães",
    mobile: "915096743",
    first_name: "Ana Maria",
    last_name: "Silva Costa"
  }

  defp data_setup do
    guardian_attrs = %{
      city: "Guimarães",
      mobile: "915196743",
      first_name: "Carla Maria",
      last_name: "Silva Costa"
    }

    user_guardian = %{
      email: "carlacosta@gmail.com",
      password: "guardian123",
      role: "guardian"
    }

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

    event_attrs = %{
      title: "Test event",
      spots_available: 30,
      start_time: ~U[2023-02-14 10:00:00.000Z],
      end_time: ~U[2023-02-14 12:30:00.000Z],
      online: false,
      notes: "Valentines"
    }

    new_user_guardian = Accounts.create_user(user_guardian)
    guardian_fixture = Map.put(guardian_attrs, :user_id, elem(new_user_guardian, 1).id)
    {:ok, guardian} = Accounts.create_guardian(guardian_fixture)

    new_user_ninja = Accounts.create_user(user_ninja)

    ninja_fixture =
      ninja_attrs
      |> Map.put(:user_id, elem(new_user_ninja, 1).id)
      |> Map.put(:guardian_id, guardian.id)

    {:ok, ninja} = Accounts.create_ninja(ninja_fixture)

    elem(new_user_guardian, 1)
  end

  setup %{conn: conn} do
    guardian_attrs = attrs()

    {:ok, guardian_user} =
      Accounts.authenticate_user(guardian_attrs.email, guardian_attrs.password)

    {:ok, jwt, _claims} =
      Authorization.encode_and_sign(guardian_user, %{
        role: guardian_user.role,
        active: guardian_user.active
      })

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put_req_header("user_id", "#{guardian_attrs[:user_id]}")

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

    event_attrs = %{
      title: "Test event",
      spots_available: 30,
      start_time: ~U[2023-02-14 10:00:00.000Z],
      end_time: ~U[2023-02-14 12:30:00.000Z],
      online: false,
      notes: "Valentines"
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
      event_attrs
      |> Map.put(:location_id, location.id)
      |> Map.put(:team_id, team.id)

    {:ok, event} = Events.create_event(event_fixture)

    {:ok, conn: conn, guardian: guardian, ninja: ninja, event: event}
  end

  describe "create enrollment" do
    test "renders enrollment when data is valid", %{
      conn: conn,
      guardian: guardian,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, enrollment_id))
      assert enrollment_attrs = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_enrollment_path(conn, :index, event.id))
      assert enrollment_attrs = json_response(conn, 200)["data"]

      conn = get(conn, Routes.ninja_enrollment_path(conn, :index, ninja.id))
      assert enrollment_attrs = json_response(conn, 200)["data"]
    end
  end

  describe "delete enrollment" do
    test "deletes enrollment when guardian of the ninja", %{
      conn: conn,
      guardian: guardian,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.event_enrollment_path(conn, :delete, event.id, enrollment_id))
      assert json_response(conn, 200)["message"]

      conn = get(conn, Routes.event_enrollment_path(conn, :show, event.id, enrollment_id))
      assert enrollment_attrs = json_response(conn, 404)["reason"]
    end
  end

  describe "update enrollment" do
    test "updates enrollment when valid data is received", %{
      conn: conn,
      guardian: guardian,
      ninja: ninja,
      event: event
    } do
      enrollment_attrs = %{enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: false}}

      conn = post(conn, Routes.event_enrollment_path(conn, :create, event.id), enrollment_attrs)
      assert %{"id" => enrollment_id} = json_response(conn, 201)["data"]

      new_enrollment_attrs = %{
        enrollment: %{event_id: event.id, ninja_id: ninja.id, accepted: true, id: enrollment_id}
      }

      conn =
        patch(
          conn,
          Routes.event_enrollment_path(conn, :update, event.id, enrollment_id),
          new_enrollment_attrs
        )

      assert json_response(conn, 200)["data"]
    end
  end
end
