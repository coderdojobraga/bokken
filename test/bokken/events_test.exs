defmodule Bokken.EventsTest do
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Repo

  describe "enrollments" do
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
        enrollments_open: ~U[2022-07-03 12:30:00.0Z],
        enrollments_close: ~U[2023-02-13 12:30:00.0Z],
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
        mobile: "+351912345678"
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

      guardian =
        valid_guardian()
        |> Map.put(:user_id, new_guardian_user.id)

      {:ok, new_guardian} = Accounts.create_guardian(guardian)

      ninja =
        valid_ninja()
        |> Map.put(:guardian_id, new_guardian.id)
        |> Map.put(:user_id, new_ninja_user.id)

      {:ok, new_ninja} = Accounts.create_ninja(ninja)

      {:ok, new_location} = Events.create_location(valid_location())

      {:ok, new_team} = Events.create_team(valid_team())

      event =
        valid_event()
        |> Map.put(:location_id, new_location.id)
        |> Map.put(:team_id, new_team.id)

      {:ok, new_event} = Events.create_event(event)

      Map.put(valid_enrollment(), :ninja_id, new_ninja.id)
      |> Map.put(:event_id, new_event.id)
    end

    def enrollment_fixture(attributes \\ %{}) do
      valid_attrs = attrs()

      {:ok, enrollment} =
        Events.create_enrollment(
          Events.get_event!(valid_attrs.event_id),
          Enum.into(attributes, valid_attrs)
        )

      enrollment
    end

    def enrollment do
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
      assert Events.get_enrollment(enrollment.id, [:ninja, :event]) == enrollment
    end

    test "get_enrollment/1 fails if the enrollment does not exist" do
      assert is_nil(Events.get_enrollment(Ecto.UUID.generate(), [:ninja, :event]))
    end

    test "create_enrollment/1 returns error if the enrollments are closed" do
      valid_attrs = attrs()
      event = Events.get_event!(valid_attrs.event_id)

      {:ok, event} =
        Events.update_event(event, %{
          start_time: ~U[2022-07-03 10:00:00.0Z],
          end_time: ~U[2022-07-03 12:30:00.0Z],
          enrollments_open: ~U[2022-07-03 07:00:00.0Z],
          enrollments_close: ~U[2022-07-03 08:00:00.0Z]
        })

      assert elem(Events.create_enrollment(event, valid_attrs), 0) == :error
    end

    test "update_enrollment/2 updates existing enrollment" do
      enrollment = enrollment()

      assert Events.update_enrollment(enrollment, %{accepted: true}) ==
               {:ok, Map.put(enrollment, :accepted, true)}
    end

    test "update_enrollment/2 fails if the enrollment does not exist" do
      enrollment = enrollment()

      assert_raise Ecto.StaleEntryError, ~r/.*/, fn ->
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

    test "delete_enrollment/1 returns error if the event has already occurred" do
      enrollment_attrs = enrollment()
      enrollment = Events.get_enrollment(enrollment_attrs.id, [:event])

      Events.update_event(enrollment.event, %{
        start_time: ~U[2022-07-03 10:00:00.0Z],
        end_time: ~U[2022-07-03 12:30:00.0Z],
        enrollments_open: ~U[2022-07-03 07:00:00.0Z],
        enrollments_close: ~U[2022-07-03 08:00:00.0Z]
      })

      assert elem(Events.delete_enrollment(enrollment), 0) == :error
    end

    test "delete_enrollment/1 fails if the enrollment does not exist" do
      enrollment = enrollment()

      assert_raise Ecto.StaleEntryError, ~r/.*/, fn ->
        Events.delete_enrollment(Map.put(enrollment, :id, Ecto.UUID.generate()))
      end
    end
  end

  describe "availabilities" do
    def availability_attrs do
      {:ok, new_mentor_user} =
        %{
          email: "pedrocosta@gmail.com",
          password: "mentor123",
          role: "mentor"
        }
        |> Accounts.create_user()

      mentor =
        %{
          first_name: "Pedro",
          last_name: "Costa",
          birthday: ~U[1992-03-14 00:00:00.000Z],
          mobile: "+351 911654321"
        }
        |> Map.put(:user_id, new_mentor_user.id)

      {:ok, new_mentor} = Accounts.create_mentor(mentor)

      {:ok, new_location} =
        %{
          address: "Test address",
          name: "Departamento de Informática"
        }
        |> Events.create_location()

      {:ok, new_team} =
        %{
          name: "Turma Yin",
          description: "Uma turma"
        }
        |> Events.create_team()

      event =
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
        |> Map.put(:location_id, new_location.id)
        |> Map.put(:team_id, new_team.id)

      {:ok, new_event} = Events.create_event(event)

      %{
        is_available: true
      }
      |> Map.put(:mentor_id, new_mentor.id)
      |> Map.put(:event_id, new_event.id)
    end

    def availability_fixture(attrs \\ %{}) do
      valid_attrs = availability_attrs()

      {:ok, availability} =
        Events.create_availability(
          Events.get_event!(valid_attrs.event_id),
          Enum.into(attrs, valid_attrs)
        )

      availability
    end

    def availability(preloads \\ []) do
      availability_fixture()
      |> Repo.preload(preloads)
    end

    test "list_availabilities/0 returns all availabilities" do
      availability = availability()
      assert Events.list_availabilities([]) == [availability]
    end

    test "list_availabilities/1 returns all availabilities of the event" do
      availability = availability([:mentor])

      assert Events.list_availabilities(%{"event_id" => availability.event_id}, [:mentor]) == [
               availability
             ]
    end

    test "get_availability!/1 returns the requested availability" do
      availability = availability([:mentor, :event])
      assert Events.get_availability!(availability.id, [:mentor, :event]) == availability
    end

    test "get_availability!/1 fails if the availability does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Events.get_availability!(Ecto.UUID.generate(), [:mentor, :event])
      end
    end

    test "create_availability/1 returns error if the enrollments are closed" do
      valid_attrs = availability_attrs()
      event = Events.get_event!(valid_attrs.event_id)

      {:ok, event} =
        Events.update_event(event, %{
          start_time: ~U[2022-07-03 10:00:00.0Z],
          end_time: ~U[2022-07-03 12:30:00.0Z],
          enrollments_open: ~U[2022-07-03 07:00:00.0Z],
          enrollments_close: ~U[2022-07-03 08:00:00.0Z]
        })

      assert elem(Events.create_availability(event, valid_attrs), 0) == :error
    end

    test "update_availability/2 updates existing availability" do
      availability = availability()

      assert Events.update_availability(availability, %{is_available: true}) ==
               {:ok, Map.put(availability, :is_available, true)}
    end

    test "update_availability/2 fails if the new value is not valid" do
      availability = availability()

      assert elem(Events.update_availability(availability, %{is_available: nil}), 0) == :error
    end

    test "update_availability/1 fails if the availability does not exist" do
      availability = availability()

      assert_raise Ecto.StaleEntryError, ~r/.*/, fn ->
        Events.update_availability(Map.put(availability, :id, Ecto.UUID.generate()), %{
          is_available: false
        })
      end
    end
  end
end
