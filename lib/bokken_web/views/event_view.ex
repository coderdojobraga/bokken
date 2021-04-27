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

  def render("event.json", %{
        event:
          %{team: %Ecto.Association.NotLoaded{}, location: %Ecto.Association.NotLoaded{}} = event
      }) do
    base(event)
    |> Map.merge(%{
      team_id: event.team_id
    })
    |> Map.merge(%{location_id: event.location_id})
  end

  def render("event.json", %{event: %{team: %Ecto.Association.NotLoaded{}} = event}) do
    base(event)
    |> Map.merge(%{
      team_id: event.team_id
    })
    |> Map.merge(%{location: render_one(event.location, LocationView, "location.json")})
  end

  def render("event.json", %{event: %{location: %Ecto.Association.NotLoaded{}} = event}) do
    base(event)
    |> Map.merge(%{
      team: render_one(event.team, TeamView, "team.json")
    })
    |> Map.merge(%{location_id: event.location_id})
  end

  def render("event.json", %{event: event}) do
    base(event)
    |> Map.merge(%{
      team: render_one(event.team, TeamView, "team.json")
    })
    |> Map.merge(%{location: render_one(event.location, LocationView, "location.json")})
  end

  defp base(event) do
    %{
      id: event.id,
      online: event.online,
      notes: event.notes,
      title: event.title
    }
  end
end
