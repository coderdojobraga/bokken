defmodule BokkenWeb.AdminController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.{Guardian, Mentor, Ninja}

  action_fallback BokkenWeb.FallbackController

  def index_mentors(conn, _params) do
    mentors = Accounts.list_mentors([:user])
    render(conn, "index.json", mentors: mentors)
  end

  def index_ninjas(conn, _params) do
    ninjas = Accounts.list_ninjas([:user])
    render(conn, "index.json", ninjas: ninjas)
  end

  def index_guardians(conn, _params) do
    guardians = Accounts.list_guardians([:user])
    render(conn, "index.json", guardians: guardians)
  end

  def update_mentor(conn, %{"mentor" => mentor_params, "user" => user_params}) do
    with {:ok, %Mentor{} = mentor} <- Accounts.update_mentor_and_user(mentor_params, user_params) do
      render(conn, "mentor.json", mentor: mentor)
    end
  end

  def update_ninja(conn, %{"ninja" => ninja_params, "user" => user_params}) do
    with {:ok, %Ninja{} = ninja} <- Accounts.update_ninja_and_user(ninja_params, user_params) do
      render(conn, "ninja.json", ninja: ninja)
    end
  end

  def update_guardian(conn, %{"guardian" => guardian_params, "user" => user_params}) do
    with {:ok, %Guardian{} = guardian} <-
           Accounts.update_guardian_and_user(guardian_params, user_params) do
      render(conn, "guardian.json", guardian: guardian)
    end
  end
end
