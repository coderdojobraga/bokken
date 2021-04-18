defmodule BokkenWeb.MentorController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor
  alias Bokken.Events.TeamMentor

  action_fallback BokkenWeb.FallbackController

  def index(conn, params) do
    mentors = Accounts.list_mentors(params)
    render(conn, "index.json", mentors: mentors)
  end

  def create(conn, %{"team_id" => team_id, "mentor_id" => mentor_id}) do
    with {:ok, %TeamMentor{} = team_mentor} <- Accounts.add_mentor_to_team(team_id, mentor_id) do
      mentor = Accounts.get_mentor!(team_mentor.mentor_id)

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.team_path(conn, :show, mentor))
      |> render("show.json", mentor: mentor)
    end
  end

  def create(conn, %{"mentor" => mentor_params} = params) when not is_map_key(params, :team_id) do
    with {:ok, %Mentor{} = mentor} <- Accounts.create_mentor(mentor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.mentor_path(conn, :show, mentor))
      |> render("show.json", mentor: mentor)
    end
  end

  def show(conn, %{"id" => id}) do
    mentor = Accounts.get_mentor!(id)
    render(conn, "show.json", mentor: mentor)
  end

  def update(conn, %{"id" => id, "mentor" => mentor_params}) do
    mentor = Accounts.get_mentor!(id)

    with {:ok, %Mentor{} = mentor} <- Accounts.update_mentor(mentor, mentor_params) do
      render(conn, "show.json", mentor: mentor)
    end
  end

  def delete(conn, %{"team_id" => team_id, "mentor_id" => mentor_id}) do
    with {_n, nil} <- Accounts.remove_mentor_team(team_id, mentor_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => id} = params) when not is_map_key(params, :team_id) do
    mentor = Accounts.get_mentor!(id)

    with {:ok, %Mentor{}} <- Accounts.delete_mentor(mentor) do
      send_resp(conn, :no_content, "")
    end
  end
end
