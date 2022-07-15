defmodule BokkenWeb.AvailabilityView do
  use BokkenWeb, :view

  alias BokkenWeb.AvailabilityView
  alias BokkenWeb.EventView
  alias BokkenWeb.MentorView

  def render("index.json", %{availability: availability}) do
    %{data: render_many(availability, AvailabilityView, "availability.json")}
  end

  def render("show.json", %{availability: availability}) do
    %{data: render_one(availability, AvailabilityView, "availability.json")}
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("availability.json", %{availability: availability}) do
    base(availability)
    |> Map.merge(event(availability))
    |> Map.merge(mentor(availability))
  end

  defp base(availability) do
    %{
      id: availability.id,
      is_available?: availability.is_available?
    }
  end

  defp event(availability) do
    if Ecto.assoc_loaded?(availability.event) do
      %{event: render_one(availability.event, EventView, "event.json")}
    else
      %{event_id: availability.event_id}
    end
  end

  defp mentor(availability) do
    if Ecto.assoc_loaded?(availability.mentor) do
      %{mentor: render_one(availability.mentor, MentorView, "mentor.json")}
    else
      %{mentor_id: availability.mentor_id}
    end
  end
end
