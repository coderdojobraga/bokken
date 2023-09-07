defmodule BokkenWeb.MentorController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor
  alias Bokken.Events.TeamMentor

  action_fallback BokkenWeb.FallbackController

  def index(conn, %{"event_id" => _event_id} = params)
      when is_map_key(conn.query_params, "attendance") do
    mentor_filter =
      case conn.query_params["attendance"] do
        "absent" -> [:both_absent, :mentor_absent]
        _ -> [:both_present, :ninja_absent]
      end

    mentors = Accounts.list_mentors(params, mentor_filter)

    conn
    |> put_status(:ok)
    |> render(:index, mentors: mentors)
  end

  def index(conn, %{"event_id" => _event_id} = params) do
    mentors = Accounts.list_mentors(params)

    conn
    |> put_status(:ok)
    |> render(:index, mentors: mentors)
  end

  def index(conn, _params) do
    mentors = Accounts.list_mentors()

    conn
    |> put_status(:ok)
    |> render(:index, mentors: mentors)
  end

  def create(conn, %{"team_id" => team_id, "mentor_id" => mentor_id})
      when is_organizer(conn) do
    with {:ok, %TeamMentor{} = team_mentor} <- Accounts.add_mentor_to_team(team_id, mentor_id) do
      mentor = Accounts.get_mentor!(team_mentor.mentor_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/mentors/#{mentor}")
      |> render(:show, mentor: mentor)
    end
  end

  def create(conn, %{"mentor" => mentor_params} = params)
      when not is_map_key(params, :team_id)
      when is_organizer(conn) do
    with {:ok, %Mentor{} = mentor} <- Accounts.create_mentor(mentor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/mentors/#{mentor}")
      |> render(:show, mentor: mentor)
    end
  end

  def show(conn, %{"id" => id}) do
    mentor = Accounts.get_mentor!(id, [:skills])

    conn
    |> put_status(:ok)
    |> render(:show, mentor: mentor)
  end

  def update(conn, %{"id" => id, "mentor" => mentor_params}) when is_organizer(conn) do
    mentor = Accounts.get_mentor!(id)

    with {:ok, %Mentor{} = mentor} <- Accounts.update_mentor(mentor, mentor_params) do
      conn
      |> put_status(:ok)
      |> render(:show, mentor: mentor)
    end
  end

  def delete(conn, %{"team_id" => team_id, "id" => mentor_id}) when is_organizer(conn) do
    with {_n, nil} <- Accounts.remove_mentor_team(team_id, mentor_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params)
      when not is_map_key(params, :team_id)
      when is_organizer(conn) do
    mentor = Accounts.get_mentor!(id)

    with {:ok, %Mentor{}} <- Accounts.delete_mentor(mentor) do
      send_resp(conn, :no_content, "")
    end
  end
end
