defmodule BokkenWeb.SkillController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias Bokken.Curriculum.{MentorSkill, NinjaSkill, Skill}

  action_fallback BokkenWeb.FallbackController

  def index(conn, %{"ninja_id" => _ninja_id} = params) do
    skills = Curriculum.list_ninja_skills(params)
    render(conn, "index.json", skills: skills)
  end

  def index(conn, %{"mentor_id" => _mentor_id} = params) do
    skills = Curriculum.list_mentor_skills(params)
    render(conn, "index.json", skills: skills)
  end

  def index(conn, _params) do
    skills = Curriculum.list_skills()
    render(conn, "index.json", skills: skills)
  end

  def create(conn, %{"skill" => skill_params}) when is_organizer(conn) do
    with {:ok, %Skill{} = skill} <- Curriculum.create_skill(skill_params) do
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

    with {:ok, %NinjaSkill{} = ninja_skill} <- Curriculum.create_ninja_skill(ninja_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", skill: skill(ninja_skill))
    end
  end

  def create(conn, %{"skill" => skill_id, "ninja_id" => ninja_id})
      when is_guardian(conn) do
    if is_guardian_of_ninja?(conn.assigns.current_user.guardian, ninja_id) do
      ninja_skill_attrs = %{
        skill_id: skill_id,
        ninja_id: ninja_id
      }

      with {:ok, %NinjaSkill{} = ninja_skill} <- Curriculum.create_ninja_skill(ninja_skill_attrs) do
        conn
        |> put_status(:created)
        |> render("show.json", skill: skill(ninja_skill))
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "You're not the ninja's guardian")
    end
  end

  def create(conn, %{"skill" => skill_id}) when is_mentor(conn) do
    mentor_skill_attrs = %{
      skill_id: skill_id,
      mentor_id: conn.assigns.current_user.mentor.id
    }

    with {:ok, %MentorSkill{} = mentor_skill} <-
           Curriculum.create_mentor_skill(mentor_skill_attrs) do
      conn
      |> put_status(:created)
      |> render("show.json", skill: skill(mentor_skill))
    end
  end

  def show(conn, %{"id" => id}) do
    skill = Curriculum.get_skill!(id)
    render(conn, "show.json", skill: skill)
  end

  def update(conn, %{"id" => id, "skill" => skill_params}) when is_organizer(conn) do
    skill = Curriculum.get_skill!(id)

    with {:ok, %Skill{} = skill} <- Curriculum.update_skill(skill, skill_params) do
      render(conn, "show.json", skill: skill)
    end
  end

  def delete(conn, %{"id" => id}) when is_organizer(conn) do
    skill = Curriculum.get_skill!(id)

    with {:ok, %Skill{}} <- Curriculum.delete_skill(skill) do
      send_resp(conn, :no_content, "")
    end
  end

  def delete(conn, %{"id" => skill_id}) when is_mentor(conn) do
    mentor_id = conn.assigns.current_user.mentor.id

    params = %{
      "mentor_id" => mentor_id,
      "skill_id" => skill_id
    }

    if Curriculum.mentor_has_skill?(params) do
      with {1, nil} <- Curriculum.delete_mentor_skill(params) do
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

    params = %{
      "ninja_id" => ninja_id,
      "skill_id" => skill_id
    }

    if Curriculum.ninja_has_skill?(params) do
      with {1, nil} <- Curriculum.delete_ninja_skill(params) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:not_found)
      |> render("error.json", reason: "You don't have that skill")
    end
  end

  def delete(conn, %{"id" => skill_id, "ninja_id" => ninja_id}) when is_guardian(conn) do
    params = %{
      "ninja_id" => ninja_id,
      "skill_id" => skill_id
    }

    if is_guardian_of_ninja?(conn.assigns.current_user.guardian, ninja_id) do
      if Curriculum.ninja_has_skill?(params) do
        with {1, nil} <- Curriculum.delete_ninja_skill(params) do
          send_resp(conn, :no_content, "")
        end
      else
        conn
        |> put_status(:not_found)
        |> render("error.json", reason: "Ninja doesn't have that skill")
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render("error.json", reason: "You're not the ninja's guardian")
    end
  end

  defp skill(user_skill) do
    Curriculum.get_skill!(user_skill.skill_id)
  end

  defp is_guardian_of_ninja?(guardian, ninja_id) do
    ninja = Accounts.get_ninja!(ninja_id)
    ninja.guardian_id == guardian.id
  end
end
