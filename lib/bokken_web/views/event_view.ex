defmodule BokkenWeb.EventView do
  use BokkenWeb, :view

  alias BokkenWeb.EventView
  alias BokkenWeb.LocationView
  alias BokkenWeb.TeamView

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    base(event)
    |> Map.merge(location(event))
    |> Map.merge(team(event))
  end

  defp base(event) do
    %{
      id: event.id,
      title: event.title,
      spots_available: event.spots_available,
      start_time: event.start_time,
      end_time: event.end_time,
      online: event.online,
      notes: event.notes
    }
  end

  defp location(event) do
    if Ecto.assoc_loaded?(event.location) do
      %{location: render_one(event.location, LocationView, "location.json")}
    else
      %{location_id: event.location_id}
    end
  end

  defp team(event) do
    if Ecto.assoc_loaded?(event.team) do
      %{team: render_one(event.team, TeamView, "team.json")}
    else
      %{team_id: event.team_id}
    end
  end
end
