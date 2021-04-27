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
      online: event.online,
      notes: event.notes,
      title: event.title
    }
  end

  defp location(%{location: %Ecto.Association.NotLoaded{}} = event) do
    %{location_id: event.location_id}
  end

  defp location(event) do
    %{location: render_one(event.location, LocationView, "location.json")}
  end

  defp team(%{location: %Ecto.Association.NotLoaded{}} = event) do
    %{
      team_id: event.team_id
    }
  end

  defp team(event) do
    %{
      team: render_one(event.team, TeamView, "team.json")
    }
  end
end
