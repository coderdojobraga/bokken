defmodule BokkenWeb.SkillView do
  use BokkenWeb, :view

  alias BokkenWeb.SkillView

  def render("index.json", %{skills: skills}) do
    %{data: render_many(skills, SkillView, "skill.json")}
  end

  def render("show.json", %{skill: skill}) do
    %{data: render_one(skill, SkillView, "skill.json")}
  end

  def render("error.json", %{reason: reason}) do
    %{error: reason}
  end

  def render("skill.json", %{skill: skill}) do
    %{
      id: skill.id,
      name: skill.name,
      description: skill.description
    }
  end
end
