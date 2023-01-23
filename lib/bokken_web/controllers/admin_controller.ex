defmodule BokkenWeb.AdminController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.{Guardian, Mentor, Ninja, User}

  action_fallback BokkenWeb.FallbackController

  def index_users(conn, _params) when is_organizer(conn) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def index_mentors(conn, _params) when is_organizer(conn) do
    mentors = Accounts.list_mentors([:user])
    render(conn, "index.json", mentors: mentors)
  end

  def index_ninjas(conn, _params) when is_organizer(conn) do
    ninjas = Accounts.list_ninjas([:user])
    render(conn, "index.json", ninjas: ninjas)
  end

  def index_guardians(conn, _params) when is_organizer(conn) do
    guardians = Accounts.list_guardians([:user])
    render(conn, "index.json", guardians: guardians)
  end

  def update_user(conn, user_params) when is_organizer(conn) do
    with {:ok, %User{} = user} <- Accounts.update_user_as_admin(user_params) do
      render(conn, "user.json", user: user)
    end
  end

  def update_mentor(conn, %{"mentor" => mentor_params, "user" => user_params})
      when is_organizer(conn) do
    with {:ok, %Mentor{} = mentor} <- Accounts.update_mentor_and_user(mentor_params, user_params) do
      render(conn, "mentor.json", mentor: mentor)
    end
  end

  def update_ninja(conn, %{"ninja" => ninja_params, "user" => user_params})
      when is_organizer(conn) do
    with {:ok, %Ninja{} = ninja} <- Accounts.update_ninja_and_user(ninja_params, user_params) do
      render(conn, "ninja.json", ninja: ninja)
    end
  end

  def update_guardian(conn, %{"guardian" => guardian_params, "user" => user_params})
      when is_organizer(conn) do
    with {:ok, %Guardian{} = guardian} <-
           Accounts.update_guardian_and_user(guardian_params, user_params) do
      render(conn, "guardian.json", guardian: guardian)
    end
  end
end
