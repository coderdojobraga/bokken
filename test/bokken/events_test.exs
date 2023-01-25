defmodule Bokken.EventsTest do
  use Bokken.DataCase

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Repo

  describe "enrollments" do
    test "list_enrollments/0 returns all enrollments" do
      enrollment = insert(:enrollment)

      assert Events.list_enrollments()
             |> Enum.map(fn x -> x.id end) == [enrollment.id]
    end

    test "list_enrollments/1 returns all enrollments of the event" do
      enrollment = insert(:enrollment)

      assert Events.list_enrollments(%{"event_id" => enrollment.event_id})
             |> Enum.map(fn x -> x.id end) == [enrollment.id]
    end

    test "list_enrollments/1 returns all enrollments of the ninja" do
      enrollment = insert(:enrollment)

      assert Events.list_enrollments(%{"ninja_id" => enrollment.ninja_id})
             |> Enum.map(fn x -> x.id end) == [enrollment.id]
    end

    test "get_enrollment/1 returns the requested enrollment" do
      e1 = insert(:enrollment)
      e2 = Events.get_enrollment(e1.id, [:ninja, :event])

      assert e1.ninja_id == e2.ninja_id
      assert e1.event_id == e2.event_id
    end

    test "get_enrollment/1 fails if the enrollment does not exist" do
      assert is_nil(Events.get_enrollment(Ecto.UUID.generate(), [:ninja, :event]))
    end

    test "create_enrollment/1 returns error if the enrollments are closed" do
      event =
        insert(:event,
          start_time: ~U[2022-07-03 10:00:00.0Z],
          end_time: ~U[2022-07-03 12:30:00.0Z],
          enrollments_open: ~U[2022-07-03 07:00:00.0Z],
          enrollments_close: ~U[2022-07-03 08:00:00.0Z]
        )

      assert elem(Events.create_enrollment(event, params_for(:enrollment)), 0) == :error
    end

    test "update_enrollment/2 updates existing enrollment" do
      enrollment = insert(:enrollment, accepted: false)

      assert Events.update_enrollment(enrollment, %{accepted: true}) ==
               {:ok, Map.put(enrollment, :accepted, true)}
    end

    test "update_enrollment/2 fails if the enrollment does not exist" do
      enrollment = insert(:enrollment)

      assert_raise Ecto.StaleEntryError, ~r/.*/, fn ->
        Events.update_enrollment(Map.put(enrollment, :id, Ecto.UUID.generate()), %{accepted: true})
      end
    end

    test "update_enrollment/2 fails if the new value is not valid" do
      enrollment = insert(:enrollment)
      assert elem(Events.update_enrollment(enrollment, %{accepted: nil}), 0) == :error
    end

    test "delete_enrollment/1 deletes existing enrollment" do
      enrollment = insert(:enrollment)
      assert elem(Events.delete_enrollment(enrollment), 0) == :ok
    end

    test "delete_enrollment/1 returns error if the event has already occurred" do
      enrollment_attrs = insert(:enrollment)
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
      enrollment = insert(:enrollment)

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
