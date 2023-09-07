defmodule Bokken.AvailabilityJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.AvailabilityJSON

  test "index" do
    all = build_list(5, :availability)
    availabilities = Enum.filter(all, & &1.is_available)
    unavailabilities = Enum.reject(all, & &1.is_available)

    rendered_availabilities =
      AvailabilityJSON.index(%{
        availabilities: availabilities,
        unavailabilities: unavailabilities,
        current_user: nil
      })

    assert rendered_availabilities == %{
             availabilities: Enum.map(availabilities, &AvailabilityJSON.data(&1, nil)),
             unavailabilities: Enum.map(unavailabilities, &AvailabilityJSON.data(&1, nil))
           }
  end

  test "show" do
    availability = build(:availability) |> forget([:event, :mentor])

    rendered_availability =
      AvailabilityJSON.show(%{availability: availability, current_user: nil})

    assert rendered_availability == %{
             data: AvailabilityJSON.data(availability, nil)
           }
  end

  test "data" do
    availability = build(:availability) |> forget([:event, :mentor])
    rendered_availability = AvailabilityJSON.data(availability, nil)

    assert rendered_availability == %{
             availability_id: availability.id,
             is_available: availability.is_available,
             notes: availability.notes,
             mentor_id: availability.mentor_id,
             event_id: availability.event_id
           }
  end
end
