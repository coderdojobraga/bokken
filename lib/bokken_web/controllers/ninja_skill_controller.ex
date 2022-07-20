defmodule BokkenWeb.NinjaSkillController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.NinjaSkill

  action_fallback BokkenWeb.FallbackController

  defguard is_ninja(conn) when conn.assigns.current_user.role === :ninja

  def index(conn, params \\ %{})

  def index(conn, %{"ninja_id" => _ninja_id} = params) do
    ninja_skills = Accounts.list_ninja_skills(params, [:skill, :ninja])
    render(conn, "index.json", ninja_skills: ninja_skills)
  end

  def index(conn, %{"skill_id" => _skill_id} = params) do
    ninja_skills = Accounts.list_ninja_skills(params, [:skill, :ninja])
    render(conn, "index.json", ninja_skills: ninja_skills)
  end

  def index(conn, _params) do
    ninja_skills = Accounts.list_ninja_skills(%{}, [:skill, :ninja])
    render(conn, "index.json", ninja_skills: ninja_skills)
  end

  def create(conn, %{"skill" => skill_id}) when is_ninja(conn) do
    ninja_skill_attrs = %{
      skill_id: skill_id,
      ninja_id: conn.assigns.current_user.ninja.id
    }

    with {:ok, %NinjaSkill{} = ninja_skill} <- Accounts.create_ninja_skill(ninja_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", ninja_skill: ninja_skill)
    end
  end

  def show(conn, %{"id" => id}) do
    ninja_skill = Accounts.get_ninja_skill!(id, [:skill, :ninja])
    render(conn, "show.json", ninja_skill: ninja_skill)
  end

  def delete(conn, %{"id" => id}) when is_ninja(conn) do
    ninja_skill = Accounts.get_ninja_skill!(id)

    if ninja_skill.ninja_id == conn.assigns.current_user.ninja.id do
      with {:ok, %NinjaSkill{}} <- Accounts.delete_ninja_skill(ninja_skill) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "Not your skill")
    end
  end
end
