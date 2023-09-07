defmodule Bokken.EventJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.EventJSON

  test "index" do
    events = build_list(5, :event)
    rendered_events = EventJSON.index(%{events: events})

    assert rendered_events == %{data: for(event <- events, do: EventJSON.data(event))}
  end

  test "show" do
    event = build(:event) |> forget([:location, :team])
    rendered_event = EventJSON.show(%{event: event})

    assert rendered_event == %{data: EventJSON.data(event)}
  end

  test "data" do
    event = build(:event) |> forget([:location, :team])
    rendered_event = EventJSON.data(event)

    assert rendered_event == %{
             id: event.id,
             title: event.title,
             spots_available: event.spots_available,
             start_time: event.start_time,
             end_time: event.end_time,
             enrollments_open: event.enrollments_open,
             enrollments_close: event.enrollments_close,
             online: event.online,
             notes: event.notes,
             location_id: nil,
             team_id: nil
           }
  end
end
