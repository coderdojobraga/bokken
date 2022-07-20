defmodule BokkenWeb.MentorSkillView do
  use BokkenWeb, :view

  alias BokkenWeb.MentorSkillView
  alias BokkenWeb.MentorView
  alias BokkenWeb.SkillView

  def render("index.json", %{mentor_skills: mentor_skills}) do
    %{data: render_many(mentor_skills, MentorSkillView, "mentor_skill.json")}
  end

  def render("show.json", %{mentor_skill: mentor_skill}) do
    %{data: render_one(mentor_skill, MentorSkillView, "mentor_skill.json")}
  end

  def render("mentor_skill.json", %{mentor_skill: mentor_skill}) do
    base(mentor_skill)
    |> Map.merge(skill(mentor_skill))
    |> Map.merge(mentor(mentor_skill))
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  defp base(mentor_skill) do
    %{id: mentor_skill.id}
  end

  defp skill(mentor_skill) do
    if Ecto.assoc_loaded?(mentor_skill.skill) do
      %{skill: render_one(mentor_skill.skill, SkillView, "skill.json")}
    else
      %{skill_id: mentor_skill.skill_id}
    end
  end

  defp mentor(mentor_skill) do
    if Ecto.assoc_loaded?(mentor_skill.mentor) and not is_nil(mentor_skill.mentor) do
      %{mentor: render_one(mentor_skill.mentor, MentorView, "mentor.json")}
    else
      %{mentor_id: mentor_skill.mentor_id}
    end
  end
end
