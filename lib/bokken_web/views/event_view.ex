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
    if Ecto.assoc_loaded?(event.team) and Ecto.assoc_loaded?(event.location) do
      %{
        id: event.id,
        online: event.online,
        notes: event.notes,
        title: event.title,
        team: render_one(event.team, TeamView, "team.json"),
        location: render_one(event.location, LocationView, "location.json")
      }
    else
      %{
        id: event.id,
        online: event.online,
        notes: event.notes,
        title: event.title,
        team_id: event.team_id,
        location_id: event.location_id
      }
    end
  end
end
