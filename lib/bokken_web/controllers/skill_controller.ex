defmodule BokkenWeb.SkillController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Skill

  action_fallback BokkenWeb.FallbackController

  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer

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
end
