defmodule BokkenWeb.SkillJSON do
  @moduledoc false

  alias Bokken.Curriculum.Skill

  def index(%{skills: skills}) do
    %{data: for(skill <- skills, do: data(skill))}
  end

  def show(%{skill: skill}) do
    %{data: data(skill)}
  end

  def render("error.json", %{reason: reason}) do
    %{error: reason}
  end

  def data(%Skill{} = skill) do
    %{
      id: skill.id,
      name: skill.name,
      description: skill.description
    }
  end
end
