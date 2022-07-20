defmodule BokkenWeb.NinjaSkillView do
  use BokkenWeb, :view

  alias BokkenWeb.NinjaSkillView
  alias BokkenWeb.NinjaView
  alias BokkenWeb.SkillView

  def render("index.json", %{ninja_skills: ninja_skills}) do
    %{data: render_many(ninja_skills, NinjaSkillView, "ninja_skill.json")}
  end

  def render("show.json", %{ninja_skill: ninja_skill}) do
    %{data: render_one(ninja_skill, NinjaSkillView, "ninja_skill.json")}
  end

  def render("ninja_skill.json", %{ninja_skill: ninja_skill}) do
    base(ninja_skill)
    |> Map.merge(skill(ninja_skill))
    |> Map.merge(ninja(ninja_skill))
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  defp base(ninja_skill) do
    %{id: ninja_skill.id}
  end

  defp skill(ninja_skill) do
    if Ecto.assoc_loaded?(ninja_skill.skill) do
      %{skill: render_one(ninja_skill.skill, SkillView, "skill.json")}
    else
      %{skill_id: ninja_skill.skill_id}
    end
  end

  defp ninja(ninja_skill) do
    if Ecto.assoc_loaded?(ninja_skill.ninja) and not is_nil(ninja_skill.ninja) do
      %{ninja: render_one(ninja_skill.ninja, NinjaView, "ninja.json")}
    else
      %{ninja_id: ninja_skill.ninja_id}
    end
  end
end
