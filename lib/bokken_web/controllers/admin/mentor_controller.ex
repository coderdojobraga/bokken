defmodule BokkenWeb.Admin.MentorController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor

  action_fallback BokkenWeb.FallbackController

  def index(conn, _params) do
    mentors = Accounts.list_mentors([:user])
    render(conn, "index.json", mentors: mentors)
  end

  def update(conn, %{"id" => id, "mentor" => mentor_params, "user" => user_params})
      when is_organizer(conn) do
    mentor = Accounts.get_mentor!(id, [:user])

    with {:ok, %Mentor{} = mentor} <-
           Accounts.update_mentor_and_user(mentor, mentor_params, user_params) do
      render(conn, "mentor.json", mentor: mentor)
    end
  end
end
