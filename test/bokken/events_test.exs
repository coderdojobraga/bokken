defmodule Bokken.EventsTest do
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Events

  import Ecto

  describe "enrollments" do
    alias Bokken.Events.{Event, Enrollment}

    @update_attrs %{accepted: true}
    @invalid_attrs %{accepted: nil}

    def valid_enrollment do
      %{
        accepted: false
      }
    end

    def valid_event do
      %{
        title: "Test event",
        spots_available: 30,
        start_time: ~U[2023-02-14 10:00:00.000Z],
        end_time: ~U[2023-02-14 12:30:00.000Z],
        online: false,
        notes: "Valentines"
      }
    end

    def valid_ninja do
      %{
        first_name: "Joana",
        last_name: "Costa",
        birthday: ~U[2007-03-14 00:00:00.000Z]
      }
    end

    def user_ninja do
      %{
        email: "joanacosta@gmail.com",
        password: "ninja123",
        role: "ninja"
      }
    end

    def user_guardian do
      %{
        email: "anacosta@gmail.com",
        password: "guardian123",
        role: "guardian"
      }
    end

    def valid_guardian do
      %{
        first_name: "Ana",
        last_name: "Costa",
        mobile: "912345678"
      }
    end

    def valid_location do
      %{
        address: "Test address",
        name: "Departamento de Informática"
      }
    end

    def valid_team do
      %{
        name: "Turma Yin",
        description: "Uma turma"
      }
    end

    def attrs do
      {:ok, new_ninja_user} = Accounts.create_user(user_ninja())
      {:ok, new_guardian_user} = Accounts.create_user(user_guardian())

      guardian = valid_guardian()
      |> Map.put(:user_id, new_guardian_user.id)

      {:ok, new_guardian} = Accounts.create_guardian(guardian)

      ninja = valid_ninja()
      |> Map.put(:guardian_id, new_guardian.id)
      |> Map.put(:user_id, new_ninja_user.id)


      {:ok, new_ninja} = Accounts.create_ninja(ninja)

      {:ok, new_location} = Events.create_location(valid_location())

      {:ok, new_team} = Events.create_team(valid_team())

      event = valid_event()
      |> Map.put(:location_id, new_location.id)
      |> Map.put(:team_id, new_team.id)

      {:ok, new_event} = Events.create_event(event)

      Map.put(valid_enrollment, :ninja_id, new_ninja.id)
      |> Map.put(:event_id, new_event.id)
    end

    def enrollment_fixture(atributes \\ %{}) do
      valid_attrs = attrs()

      {:ok, enrollment} =
        atributes
        |> Enum.into(valid_attrs)
        |> Events.create_enrollment()

      enrollment
    end

    def enrollment() do
      enrollment = enrollment_fixture()

      enrollment
      |> Map.put(:event, Events.get_event!(enrollment.event_id))
      |> Map.put(:ninja, Accounts.get_ninja!(enrollment.ninja_id))
    end

    test "list_enrollments/0 returns all enrollments" do
      enrollment = enrollment()
      assert Events.list_enrollments() == [enrollment]
    end

    test "list_enrollments/1 returns all enrollments of the event" do
      enrollment = enrollment()
      assert Events.list_enrollments(%{"event_id" => enrollment.event_id}) == [enrollment]
    end

    test "list_enrollments/1 returns all enrollments of the ninja" do
      enrollment = enrollment()
      assert Events.list_enrollments(%{"ninja_id" => enrollment.ninja_id}) == [enrollment]
    end

    test "get_enrollment/1 returns the requested enrollment" do
      enrollment = enrollment()
      assert Events.get_enrollment!(enrollment.id, [:ninja, :event]) == enrollment
    end

    test "get_enrollment/1 fails if the enrollment does not exist" do
      assert_raise Ecto.NoResultsError, ~r/.*/,
        fn ->
          Events.get_enrollment!(Ecto.UUID.generate(), [:ninja, :event])
        end
    end

    test "update_enrollment/2 updates existing enrollment" do
      enrollment = enrollment()
      assert Events.update_enrollment(enrollment, %{accepted: true}) == {:ok, Map.put(enrollment, :accepted, true)}
    end

    test "update_enrollment/2 fails if the enrollment does not exist" do
      enrollment = enrollment()
      assert_raise Ecto.StaleEntryError, ~r/.*/,
        fn ->
          Events.update_enrollment(Map.put(enrollment, :id, Ecto.UUID.generate()), %{accepted: true})
        end
    end

    test "update_enrollment/2 fails if the new value is not valid" do
      enrollment = enrollment()
      assert elem(Events.update_enrollment(enrollment, %{accepted: nil}), 0) == :error
    end

    test "delete_enrollment/1 deletes existing enrollment" do
      enrollment = enrollment()
      assert elem(Events.delete_enrollment(enrollment), 0) == :ok
    end

    test "delete_enrollment/1 fails if the enrollment does not exist" do
      enrollment = enrollment()
      assert_raise Ecto.StaleEntryError, ~r/.*/,
        fn ->
          Events.delete_enrollment(Map.put(enrollment, :id, Ecto.UUID.generate()))
        end
    end
  end
end
