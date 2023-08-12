defmodule BokkenWeb.SkillJSON do
  alias Bokken.Curriculum.Skill

  def index(%{skills: skills}) do
    %{data: for(skill <- skills, do: data(skill))}
  end

  def show(%{skill: skill}) do
    %{data: data(skill)}
  end

  def data(%Skill{} = skill) do
    %{
      id: skill.id,
      name: skill.name,
      description: skill.description
    }
  end
end
