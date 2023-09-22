defmodule BokkenWeb.EventJSON do
  @moduledoc false
  alias BokkenWeb.LocationJSON
  alias BokkenWeb.TeamJSON
  alias Bokken.Events.Event

  def index(%{events: events}) do
    %{data: for(event <- events, do: data(event))}
  end

  def show(%{event: event}) do
    %{data: data(event)}
  end

  def data(%Event{}= event) do
    %{
      id: event.id,
      title: event.title,
      spots_available: event.spots_available,
      start_time: event.start_time,
      end_time: event.end_time,
      online: event.online,
      notes: event.notes,
      enrollments_open: event.enrollments_open,
      enrollments_close: event.enrollments_close
    }
    |> Map.merge(location(event))
    |> Map.merge(team(event))
  end

  def data(%{success: success_emails, fail: failed_emails}) do
    %{
      success: success_emails,
      fail: failed_emails
    }
  end

  defp location(event) do
    if Ecto.assoc_loaded?(event.location) do
      %{location: LocationJSON.data(event.location)}
    else
      %{location_id: event.location_id}
    end
  end

  defp team(event) do
    if Ecto.assoc_loaded?(event.team) do
      %{team: TeamJSON.data(event.team)}
    else
      %{team_id: event.team_id}
    end
  end
end
