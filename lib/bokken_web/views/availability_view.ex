defmodule BokkenWeb.AvailabilityView do
  use BokkenWeb, :view

  alias BokkenWeb.AvailabilityView
  alias BokkenWeb.EventView
  alias BokkenWeb.MentorView

  def render("index.json", %{
        availabilities: availabilities,
        unavailabilities: unavailabilities,
        current_user: current_user
      }) do
    %{
      availabilities:
        render_many(availabilities, AvailabilityView, "availability.json",
          current_user: current_user
        ),
      unavailabilities:
        render_many(unavailabilities, AvailabilityView, "unavailability.json",
          current_user: current_user
        )
    }
  end

  def render("show.json", %{availability: availability, current_user: current_user}) do
    %{
      data:
        render_one(availability, AvailabilityView, "availability.json", current_user: current_user)
    }
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("availability.json", %{availability: availability, current_user: current_user}) do
    %{
      availability_id: availability.id,
      is_available: availability.is_available,
      notes: availability.notes
    }
    |> Map.merge(event(availability))
    |> Map.merge(mentor(availability, current_user))
  end

  def render("unavailability.json", %{availability: availability, current_user: current_user}) do
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
      render_one(availability.event, EventView, "event.json")
    else
      %{event_id: availability.event_id}
    end
  end

  defp mentor(availability, current_user) do
    if Ecto.assoc_loaded?(availability.mentor) do
      render_one(availability.mentor, MentorView, "mentor.json", current_user: current_user)
    else
      %{mentor_id: availability.mentor_id}
    end
  end
end
