defmodule BokkenWeb.SkillJSON do
  def index(%{skills: skills}) do
    %{data: for(skill <- skills, do: data(%{skill: skill}))}
  end

  def show(%{skill: skill}) do
    %{data: data(%{skill: skill})}
  end

  def error(%{reason: reason}) do
    %{error: reason}
  end

  def data(%{skill: skill}) do
    %{
      id: skill.id,
      name: skill.name,
      description: skill.description
    }
  end
end
