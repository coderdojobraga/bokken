defmodule BokkenWeb.EventController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Events.Event
  alias Bokken.Mailer
  alias BokkenWeb.EventsEmails
  import Bokken.Guards

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    events = Events.list_events(params)
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) when is_organizer(conn) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.event_path(conn, :show, event))
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id, [:location, :team])
    render(conn, "show.json", event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) when is_organizer(conn) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) when is_organizer(conn) do
    event = Events.get_event!(id)

    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end

  def notify_signup(conn, params) when is_organizer(conn) do
    event = Events.get_next_event!([:location])

    res =
      Accounts.list_users()
      |> Enum.filter(fn u -> u.active and u.verified and u.role in [:guardian, :mentor] end)
      |> send_email(fn user -> EventsEmails.event_reminder_email(user, event) end)

    status =
      if Enum.empty?(res[:fail]) do
        :ok
      else
        :internal_server_error
      end

    if Map.has_key?(params, "no_print") do
      conn
      |> put_status(status)
      |> assign(:result, res)
    else
      conn
      |> put_status(status)
      |> assign(:result, res)
      |> render("emails.json", res)
    end
  end

  def notify_selected(conn, params) when is_organizer(conn) do
    event = Events.get_next_event!([:location])
    lectures = Events.list_lectures(%{"event_id" => event.id}, [:mentor, :ninja, :event])

    mentor_res =
      lectures
      |> Enum.map(fn lecture ->
        Accounts.get_user!(lecture.mentor.user_id)
        |> Map.put(:lecture, lecture)
      end)
      |> send_email(fn user ->
        EventsEmails.event_selected_mentor_email(event, user.lecture, to: user.email)
      end)

    ninja_res =
      lectures
      |> Enum.map(fn lecture ->
        Accounts.get_user!(Accounts.get_guardian!(lecture.ninja.guardian_id).user_id)
        |> Map.put(:lecture, lecture)
      end)
      |> send_email(fn user ->
        EventsEmails.event_selected_ninja_email(event, user.lecture, to: user.email)
      end)

    res = %{
      success: mentor_res[:success] ++ ninja_res[:success],
      fail: mentor_res[:fail] ++ ninja_res[:fail]
    }

    status =
      if Enum.empty?(res[:fail]) do
        :ok
      else
        :internal_server_error
      end

    if Map.has_key?(params, "no_print") do
      conn
      |> put_status(status)
      |> assign(:result, res)
    else
      conn
      |> put_status(status)
      |> assign(:result, res)
      |> render("emails.json", res)
    end
  end

  defp send_email(users, email) do
    users
    |> List.foldl(
      %{success: [], fail: []},
      fn user, accumulator ->
        case Mailer.deliver(email.(user)) do
          {:ok, _} ->
            %{success: [user.email | accumulator[:success]], fail: accumulator[:fail]}

          {:error, _} ->
            %{success: [accumulator[:success]], fail: [user.email | accumulator[:fail]]}
        end
      end
    )
  end
end
