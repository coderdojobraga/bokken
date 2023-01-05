defmodule BokkenWeb.AdminController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Mentor

  action_fallback BokkenWeb.FallbackController

  def index_mentors(conn, _params) do
    mentors = Accounts.list_mentors([:user])
    render(conn, "index.json", mentors: mentors)
  end

  def update_mentor(conn, %{"mentor" => mentor_params, "user" => user_params}) do
    with {:ok, %Mentor{} = mentor} <- Accounts.update_mentor_and_user(mentor_params, user_params) do
      render(conn, "mentor.json", mentor: mentor)
    end
  end
end
