defmodule BokkenWeb.EventController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Events.Event
  alias Bokken.Mailer
  alias BokkenWeb.EventsEmails

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor
  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer

  def index(conn, params) do
    events = Events.list_events(params)
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
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

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    with {:ok, %Event{}} <- Events.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end

  def notify_signup(conn, _params) when is_organizer(conn) do
    event = Events.get_next_event!([:location])

    res =
      Accounts.list_users()
      |> Enum.filter(fn u -> u.active and u.verified and u.role in [:guardian, :mentor] end)
      |> send_email(fn user -> EventsEmails.event_reminder_email(user, event) end)

    conn
    |> put_status(:ok)
    |> render("emails.json", res)
  end

  def notify_selected(conn, _params) when is_organizer(conn) do
    event = Events.get_next_event!([:location])
    lectures = Events.list_lectures(%{"event_id" => event.id}, [:mentor, :ninja, :event])

    mentor_res =
      lectures
      |> send_email(fn lecture ->
        EventsEmails.event_selected_mentor_email(lecture.event, lecture,
          to: Accounts.get_user!(lecture.mentor.user_id).email
        )
      end)

    ninja_res =
      lectures
      |> send_email(fn lecture ->
        EventsEmails.event_selected_ninja_email(lecture.event, lecture,
          to: Accounts.get_user!(Accounts.get_guardian!(lecture.ninja.guardian_id)).email
        )
      end)

    res = %{
      success: mentor_res[:success] ++ ninja_res[:success],
      fail: mentor_res[:fail] ++ ninja_res[:fail]
    }

    conn
    |> put_status(:ok)
    |> render("emails.json", res)
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
