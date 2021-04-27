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
    %{
      id: event.id,
      online: event.online,
      notes: event.notes,
      title: event.title
    }
    |> (fn map ->
          if Ecto.assoc_loaded?(event.team) do
            Map.merge(map, %{
              team: render_one(event.team, TeamView, "team.json")
            })
          else
            Map.merge(map, %{
              team_id: event.team_id
            })
          end
        end).()
    |> (fn map ->
          if Ecto.assoc_loaded?(event.location) do
            Map.merge(map, %{location: render_one(event.location, LocationView, "location.json")})
          else
            Map.merge(map, %{location_id: event.location_id})
          end
        end).()
  end
end
