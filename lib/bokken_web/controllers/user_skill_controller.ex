defmodule BokkenWeb.UserSkillController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.UserSkill

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja
  defguard is_mentor(conn) when conn.assigns.current_user.role === :mentor

  def index(conn, params \\ %{})

  def index(conn, %{"ninja_id" => _ninja_id} = params) do
    user_skills = Accounts.list_user_skills(params, [:skill, :ninja])
    render(conn, "index.json", user_skills: user_skills, render_user: false)
  end

  def index(conn, %{"mentor_id" => _mentor_id} = params) do
    user_skills = Accounts.list_user_skills(params, [:skill, :mentor])
    render(conn, "index.json", user_skills: user_skills)
  end

  def index(conn, %{"skill_id" => _skill_id} = params) do
    user_skills = Accounts.list_user_skills(params, [:skill, :ninja, :mentor])
    render(conn, "index.json", user_skills: user_skills)
  end

  def index(conn, _params) do
    user_skills = Accounts.list_user_skills(%{}, [:skill, :mentor, :ninja])
    render(conn, "index.json", user_skills: user_skills)
  end

  def create(conn, %{"skill" => skill_id}) when is_ninja(conn) do
    user_skill_attrs = %{
      skill_id: skill_id,
      ninja_id: conn.assigns.current_user.ninja.id
    }

    with {:ok, %UserSkill{} = user_skill} <- Accounts.create_user_skill(user_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", user_skill: user_skill)
    end
  end

  def create(conn, %{"skill" => skill_id}) when is_mentor(conn) do
    user_skill_attrs = %{
      skill_id: skill_id,
      mentor_id: conn.assigns.current_user.mentor.id
    }

    with {:ok, %UserSkill{} = user_skill} <- Accounts.create_user_skill(user_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", user_skill: user_skill)
    end
  end

  def show(conn, %{"id" => id}) do
    user_skill = Accounts.get_user_skill!(id, [:skill, :ninja, :mentor])
    render(conn, "show.json", user_skill: user_skill)
  end

  def delete(conn, %{"id" => id}) when is_mentor(conn) do
    user_skill = Accounts.get_user_skill!(id)

    if user_skill.mentor_id == conn.assigns.current_user.mentor.id do
      with {:ok, %UserSkill{}} <- Accounts.delete_user_skill(user_skill) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "Not your skill")
    end
  end

  def delete(conn, %{"id" => id}) when is_ninja(conn) do
    user_skill = Accounts.get_user_skill!(id)

    if user_skill.ninja_id == conn.assigns.current_user.ninja.id do
      with {:ok, %UserSkill{}} <- Accounts.delete_user_skill(user_skill) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "Not your skill")
    end
  end
end
