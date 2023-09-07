defmodule BokkenWeb.AvailabilityJSON do
  alias Bokken.Events.Availability

  alias BokkenWeb.EventJSON
  alias BokkenWeb.MentorJSON

  def index(%{
        availabilities: availabilities,
        unavailabilities: unavailabilities,
        current_user: current_user
      }) do
    %{
      availabilities: for(availability <- availabilities, do: data(availability, current_user)),
      unavailabilities:
        for(availability <- unavailabilities, do: data(availability, current_user))
    }
  end

  def show(%{availability: availability, current_user: current_user}) do
    %{data: data(availability, current_user)}
  end

  def data(%Availability{} = availability, current_user) do
    %{
      availability_id: availability.id,
      is_available: availability.is_available,
      notes: availability.notes
    }
    |> Map.merge(event(availability))
    |> Map.merge(mentor(availability, current_user))
  end

  defp event(availability) do
    if Ecto.assoc_loaded?(availability.event) do
      EventJSON.data(availability.event)
    else
      %{event_id: availability.event_id}
    end
  end

  defp mentor(availability, current_user) do
    if Ecto.assoc_loaded?(availability.mentor) do
      MentorJSON.data(availability.mentor, current_user)
    else
      %{mentor_id: availability.mentor_id}
    end
  end
end
