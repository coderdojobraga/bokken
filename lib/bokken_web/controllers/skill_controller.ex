defmodule BokkenWeb.SkillController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.{MentorSkill, NinjaSkill, Skill}

  action_fallback BokkenWeb.FallbackController

  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer
  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor

  def index(conn, %{"ninja_id" => ninja_id}) do
    skills = Accounts.list_ninja_skills(ninja_id)
    render(conn, "index.json", skills: skills)
  end

  def index(conn, %{"mentor_id" => mentor_id}) do
    skills = Accounts.list_mentor_skills(mentor_id)
    render(conn, "index.json", skills: skills)
  end

  def index(conn, _params) do
    skills = Accounts.list_skills()
    render(conn, "index.json", skills: skills)
  end

  def create(conn, %{"skill" => skill_params}) when is_organizer(conn) do
    with {:ok, %Skill{} = skill} <- Accounts.create_skill(skill_params) do
      conn
      |> put_status(:created)
      |> render("show.json", skill: skill)
    end
  end

  def create(conn, %{"skill" => skill_id}) when is_ninja(conn) do
    ninja_skill_attrs = %{
      skill_id: skill_id,
      ninja_id: conn.assigns.current_user.ninja.id
    }

    with {:ok, %NinjaSkill{} = ninja_skill} <- Accounts.create_ninja_skill(ninja_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", skill: skill(ninja_skill))
    end
  end

  def create(conn, %{"skill" => skill_id}) when is_mentor(conn) do
    mentor_skill_attrs = %{
      skill_id: skill_id,
      mentor_id: conn.assigns.current_user.mentor.id
    }

    with {:ok, %MentorSkill{} = mentor_skill} <- Accounts.create_mentor_skill(mentor_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", skill: skill(mentor_skill))
    end
  end

  def show(conn, %{"id" => id}) do
    skill = Accounts.get_skill!(id)
    render(conn, "show.json", skill: skill)
  end

  def update(conn, %{"id" => id, "skill" => skill_params}) when is_organizer(conn) do
    skill = Accounts.get_skill!(id)

    with {:ok, %Skill{} = skill} <- Accounts.update_skill(skill, skill_params) do
      render(conn, "show.json", skill: skill)
    end
  end

  def delete(conn, %{"id" => id}) when is_organizer(conn) do
    skill = Accounts.get_skill!(id)

    with {:ok, %Skill{}} <- Accounts.delete_skill(skill) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => skill_id}) when is_mentor(conn) do
    mentor_id = conn.assigns.current_user.mentor.id

    if Accounts.mentor_has_skill?(mentor_id, skill_id) do
      with {1, nil} <- Accounts.delete_mentor_skill(mentor_id, skill_id) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "You don't have that skill")
    end
  end

  def delete(conn, %{"id" => skill_id}) when is_ninja(conn) do
    ninja_id = conn.assigns.current_user.ninja.id

    if Accounts.ninja_has_skill?(ninja_id, skill_id) do
      with {1, nil} <- Accounts.delete_ninja_skill(ninja_id, skill_id) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "You don't have that skill")
    end
  end

  defp skill(user_skill) do
    Accounts.get_skill!(user_skill.skill_id)
  end
end
