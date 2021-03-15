defmodule BokkenWeb.MentorController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    mentors = Accounts.list_mentors()
    render(conn, "index.json", mentors: mentors)
  end

  def create(conn, %{"mentor" => mentor_params}) do
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

  def delete(conn, %{"id" => id}) do
    mentor = Accounts.get_mentor!(id)

    with {:ok, %Mentor{}} <- Accounts.delete_mentor(mentor) do
      send_resp(conn, :no_content, "")
    end
  end
end
