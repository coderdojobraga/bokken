defmodule BokkenWeb.UserSkillView do
  use BokkenWeb, :view

  alias BokkenWeb.MentorView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.SkillView
  alias BokkenWeb.UserSkillView

  def render("index.json", %{user_skills: user_skills, render_user: render_user}) do
    if render_user do
      %{data: render_many(user_skills, UserSkillView, "user_skill.json")}
    else
      %{data: render_many(Enum.map(user_skills, fn us -> us.skill end), SkillView, "skill.json")}
    end
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("user_skill.json", %{user_skill: user_skill}) do
    if is_nil(user_skill.ninja) do
      base(user_skill)
      |> Map.merge(skill(user_skill))
      |> Map.merge(mentor(user_skill))
    else
      base(user_skill)
      |> Map.merge(skill(user_skill))
      |> Map.merge(ninja(user_skill))
    end
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  defp base(user_skill) do
    %{id: user_skill.id}
  end

  defp skill(user_skill) do
    if Ecto.assoc_loaded?(user_skill.skill) do
      %{skill: render_one(user_skill.skill, SkillView, "skill.json")}
    else
      %{skill_id: user_skill.skill_id}
    end
  end

  defp mentor(user_skill) do
    if Ecto.assoc_loaded?(user_skill.mentor) and not is_nil(user_skill.mentor) do
      %{mentor: render_one(user_skill.mentor, MentorView, "mentor.json")}
    else
      %{mentor_id: user_skill.mentor_id}
    end
  end

  defp ninja(user_skill) do
    if Ecto.assoc_loaded?(user_skill.ninja) and not is_nil(user_skill.ninja) do
      %{ninja: render_one(user_skill.ninja, NinjaView, "ninja.json")}
    else
      %{ninja_id: user_skill.ninja_id}
    end
  end
end
