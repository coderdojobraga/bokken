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
    event = Events.get_next_event!()

    res =
      Accounts.list_users()
      |> Enum.filter(fn u -> u.active and u.verified and u.role in [:guardian, :mentor] end)
      |> List.foldl(
        %{success: [], fail: []},
        fn user, accumulator ->
          case Mailer.deliver(EventsEmails.event_reminder_email(user, event)) do
            {:ok, _} ->
              %{success: [user.email | accumulator[:success]], fail: accumulator[:fail]}

            {:error, _} ->
              %{success: [accumulator[:success]], fail: [user.email | accumulator[:fail]]}
          end
        end
      )

    conn
    |> put_status(:ok)
    |> render("emails.json", res)
  end

  def notify_selected(conn, _params) when is_organizer(conn) do
    event = Events.get_next_event!()
    lectures = Events.list_lectures(%{"event_id" => event.id}, [:mentor, :ninja])

    mentor_emails =
      lectures
      |> List.foldl(
        %{success: [], fail: []},
        fn lecture, accumulator ->
          user = Accounts.get_user!(lecture.mentor.user_id)

          case Mailer.deliver(
                 EventsEmails.event_selected_mentor_email(event, lecture, to: user.email)
               ) do
            {:ok, _} ->
              %{success: [user.email | accumulator[:success]], fail: accumulator[:fail]}

            {:error, _} ->
              %{success: [accumulator[:success]], fail: [user.email | accumulator[:fail]]}
          end
        end
      )

    res =
      lectures
      |> List.foldl(
        mentor_emails,
        fn lecture, accumulator ->
          guardian = Accounts.get_guardian!(lecture.ninja.guardian_id)
          user = Accounts.get_user!(guardian.user_id)

          case Mailer.deliver(
                 EventsEmails.event_selected_ninja_email(event, lecture, to: user.email)
               ) do
            {:ok, _} ->
              %{success: [user.email | accumulator[:success]], fail: accumulator[:fail]}

            {:error, _} ->
              %{success: [accumulator[:success]], fail: [user.email | accumulator[:fail]]}
          end
        end
      )

    conn
    |> put_status(:ok)
    |> render("emails.json", res)
  end
end
