defmodule Bokken.Curriculum.Skill do
  @moduledoc """
  A skill a mentor has / a ninja is learning
  """
  use Bokken.Schema

  @required_fields [:name, :description]

  schema "skills" do
    field :name, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(skill, attrs) do
    skill
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:name], name: :skills_pkey)
  end
end
