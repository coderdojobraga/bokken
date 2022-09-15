defmodule Bokken.Events.EventAdmin do
  @moduledoc """
  The admin view config of events
  """
  alias Bokken.{Events, Pairings}
  def list_actions(_conn) do
    [
      notify_signups: %{name: "Notify signups", action: fn c, _e -> notify_signups(c) end},
      notify_selected: %{name: "Notify selected", action: fn c, _e -> notify_selected(c) end},
      create_pairings: %{name: "Create pairings", action: fn c, _e -> create_pairings() end}
    ]
  end

  defp notify_signups(conn) do
    conn = BokkenWeb.EventController.notify_signup(conn, %{})
    if conn.status == 200 do
      :ok
    else
      {:error, conn.assigns.result}
    end
  end

  defp notify_selected(conn) do
    conn = BokkenWeb.EventController.notify_signup(conn, %{})
    if conn.status == 200 do
      :ok
    else
      {:error, conn.assigns.result}
    end
  end

  defp create_pairings() do
    Pairings.create_pairings(Events.get_next_event!().id)
    :ok
  end

  def form_fields(_) do
    [
      title: nil,
      start_time: nil,
      end_time: nil,
      enrollments_open: nil,
      enrollments_close: nil
    ]
  end
end
