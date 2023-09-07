defmodule BokkenWeb.EventController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Events
  alias Bokken.Events.Event

  alias Bokken.Mailer
  alias BokkenWeb.EventsEmails

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    events = Events.list_events(params)

    conn
    |> put_status(:ok)
    |> render(:index, events: events)
  end

  def create(conn, %{"event" => event_params}) when is_organizer(conn) do
    with {:ok, %Event{} = event} <- Events.create_event(event_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/events/#{event}")
      |> render(:show, event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)

    conn
    |> put_status(:ok)
    |> render(:show, event: event)
  end

  def update(conn, %{"id" => id, "event" => event_params}) when is_organizer(conn) do
    event = Events.get_event!(id)

    with {:ok, %Event{} = event} <- Events.update_event(event, event_params) do
      conn
      |> put_status(:ok)
      |> render(:show, event: event)
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

    result =
      Events.list_notifiable_signup_users()
      |> send_email(fn user -> EventsEmails.event_reminder_email(user, event) end)

    if Map.has_key?(params, "no_print") do
      conn
      |> put_status(get_status(result))
      |> assign(:result, result)
    else
      conn
      |> put_status(get_status(result))
      |> assign(:result, result)
      |> render(:emails, result)
    end
  end

  def notify_selected(conn, params) when is_organizer(conn) do
    event = Events.get_next_event!([:location])

    mentor_result =
      Events.list_notifiable_selected_mentors(event)
      |> send_email(fn user ->
        EventsEmails.event_selected_mentor_email(event, user.lecture, to: user.email)
      end)

    ninja_result =
      Events.list_notifiable_selected_ninjas(event)
      |> send_email(fn user ->
        EventsEmails.event_selected_ninja_email(event, user.lecture, to: user.email)
      end)

    not_coming_ninjas_result =
      Events.list_not_coming_ninjas(event)
      |> case do
        [] ->
          %{success: [], fail: []}

        list ->
          Enum.map(list, fn e ->
            Accounts.get_user!(
              Accounts.get_guardian!(Accounts.get_ninja!(e.ninja_id).guardian_id).user_id
            )
            |> Map.put(:ninja, Accounts.get_ninja!(e.ninja_id))
          end)
          |> send_email(fn user ->
            EventsEmails.confirm_ninja_not_participation(event, user.ninja, to: user.email)
          end)
      end

    result = %{
      success:
        mentor_result[:success] ++ ninja_result[:success] ++ not_coming_ninjas_result[:success],
      fail: mentor_result[:fail] ++ ninja_result[:fail] ++ not_coming_ninjas_result[:fail]
    }

    if Map.has_key?(params, "no_print") do
      conn
      |> put_status(get_status(result))
      |> assign(:result, result)
    else
      conn
      |> put_status(get_status(result))
      |> assign(:result, result)
      |> render(:emails, result)
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

  defp get_status(result) do
    if Enum.empty?(result[:fail]) do
      :ok
    else
      :internal_server_error
    end
  end
end
