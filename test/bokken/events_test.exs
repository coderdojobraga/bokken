defmodule Bokken.EventsTest do
  use Bokken.DataCase

  alias Bokken.Events

  import Bokken.Factory

  describe "enrollments" do
    test "list_enrollments/0 returns all enrollments" do
      enrollment = insert(:enrollment)

      enrollments = Events.list_enrollments()

      assert hd(enrollments).id == enrollment.id
    end

    test "list_enrollments/1 returns all enrollments of the event" do
      enrollment = insert(:enrollment)
      enrollments = Events.list_enrollments(%{"event_id" => enrollment.event_id})

      assert hd(enrollments).id == enrollment.id
    end

    test "list_enrollments/1 returns all enrollments of the ninja" do
      enrollment = insert(:enrollment)
      enrollments = Events.list_enrollments(%{"ninja_id" => enrollment.ninja_id})

      assert hd(enrollments).id == enrollment.id
    end

    test "get_enrollment/1 returns the requested enrollment" do
      enrollment = insert(:enrollment)
      assert Events.get_enrollment(enrollment.id, [:ninja, :event]).id == enrollment.id
    end

    test "get_enrollment/1 fails if the enrollment does not exist" do
      assert is_nil(Events.get_enrollment(Ecto.UUID.generate(), [:ninja, :event]))
    end

    test "create_enrollment/2 returns error if the enrollments are closed" do
      valid_attrs = insert(:enrollment)
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

    # test "guardian_create_enrollment/4 creates a new enrollment" do
    #   guardian = insert(:guardian)
    #   ninja = insert(:ninja)
    #   valid_attrs = insert(:enrollment, %{ninja_id: ninja.id})
    #   event = Events.get_event!(valid_attrs.event_id)

    #   assert elem(Events.guardian_create_enrollment(event, guardian.id, ninja.id, valid_attrs), 0) == :ok
    # end

    test "guardian_create_enrollment/4 returns error if it's not the ninja guaridan" do
      valid_attrs = insert(:enrollment)
      event = Events.get_event!(valid_attrs.event_id)

      assert elem(Events.guardian_create_enrollment(event, Ecto.UUID.generate(), valid_attrs.ninja_id, valid_attrs), 0) == :error
    end

    test "update_enrollment/2 updates existing enrollment" do
      enrollment = insert(:enrollment)

      assert Events.update_enrollment(enrollment, %{accepted: true}) ==
               {:ok, Map.put(enrollment, :accepted, true)}
    end

    test "update_enrollment/2 fails if the enrollment does not exist" do
      enrollment = insert(:enrollment, %{accepted: false})
      new_uuid = Ecto.UUID.generate()
      enrollment = Map.put(enrollment, :id, new_uuid)

      assert_raise Ecto.StaleEntryError, fn ->
        Events.update_enrollment(enrollment, %{accepted: true})
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
    test "list_availabilities/0 returns all availabilities" do
      availability = insert(:availability)
      availabilities = Events.list_availabilities([])

      assert hd(availabilities).id == availability.id
    end

    test "list_availabilities/1 returns all availabilities of the event" do
      event = insert(:event)
      availability = insert(:availability, %{event: event})

      availabilities =
        Events.list_availabilities(%{"event_id" => availability.event_id}, [:mentor])

      assert hd(availabilities).id == availability.id
    end

    test "get_availability!/1 returns the requested availability" do
      availability = insert(:availability)
      queried_availability = Events.get_availability!(availability.id, [:mentor, :event])
      assert queried_availability.id == availability.id
    end

    test "get_availability!/1 fails if the availability does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Events.get_availability!(Ecto.UUID.generate(), [:mentor, :event])
      end
    end

    test "create_availability/1 returns error if the enrollments are closed" do
      valid_attrs = insert(:availability)
      event = insert(:event)

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
      availability = insert(:availability)

      assert Events.update_availability(availability, %{is_available: true}) ==
               {:ok, Map.put(availability, :is_available, true)}
    end

    test "update_availability/2 fails if the new value is not valid" do
      availability = insert(:availability)

      assert elem(Events.update_availability(availability, %{is_available: nil}), 0) == :error
    end

    test "update_availability/1 fails if the availability does not exist" do
      availability = insert(:availability, %{is_available: true})
      fake_id = Ecto.UUID.generate()

      availability = Map.put(availability, :id, fake_id)

      assert_raise Ecto.StaleEntryError, fn ->
        Events.update_availability(availability, %{is_available: false})
      end
    end
  end
end
