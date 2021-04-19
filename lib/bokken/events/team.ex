defmodule Bokken.Events.Team do
  @moduledoc """
  A team is a working group formed by ninjas and mentors.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Events.{TeamMentor, TeamNinja}

  @required_fields [:name]
  @optional_fields [:description]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "teams" do
    field :description, :string
    field :name, :string

    many_to_many :ninjas, Ninja, join_through: TeamNinja
    many_to_many :mentors, Mentor, join_through: TeamMentor

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
