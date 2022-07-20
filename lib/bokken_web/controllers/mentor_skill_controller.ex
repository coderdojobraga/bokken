defmodule BokkenWeb.MentorSkillController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.MentorSkill

  action_fallback BokkenWeb.FallbackController

  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor

  def index(conn, params \\ %{})

  def index(conn, %{"mentor_id" => _mentor_id} = params) do
    mentor_skills = Accounts.list_mentor_skills(params, [:skill, :mentor])
    render(conn, "index.json", mentor_skills: mentor_skills)
  end

  def index(conn, %{"skill_id" => _skill_id} = params) do
    mentor_skills = Accounts.list_mentor_skills(params, [:skill, :mentor])
    render(conn, "index.json", mentor_skills: mentor_skills)
  end

  def index(conn, _params) do
    mentor_skills = Accounts.list_mentor_skills(%{}, [:skill, :mentor])
    render(conn, "index.json", mentor_skills: mentor_skills)
  end

  def create(conn, %{"skill" => skill_id}) when is_mentor(conn) do
    mentor_skill_attrs = %{
      skill_id: skill_id,
      mentor_id: conn.assigns.current_user.mentor.id
    }

    with {:ok, %MentorSkill{} = mentor_skill} <- Accounts.create_mentor_skill(mentor_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", mentor_skill: mentor_skill)
    end
  end

  def show(conn, %{"id" => id}) do
    mentor_skill = Accounts.get_mentor_skill!(id, [:skill, :mentor])
    render(conn, "show.json", mentor_skill: mentor_skill)
  end

  def delete(conn, %{"id" => id}) when is_mentor(conn) do
    mentor_skill = Accounts.get_mentor_skill!(id)

    if mentor_skill.mentor_id == conn.assigns.current_user.mentor.id do
      with {:ok, %MentorSkill{}} <- Accounts.delete_mentor_skill(mentor_skill) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "Not your skill")
    end
  end
end
