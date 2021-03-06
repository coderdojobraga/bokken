defmodule Bokken.Events.Team do
  @moduledoc """
  A team is a working group formed by ninjas and mentors.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Events.{Event, TeamMentor, TeamNinja}

  @required_fields [:name]
  @optional_fields [:description]

  schema "teams" do
    field :description, :string
    field :name, :string

    many_to_many :ninjas, Ninja, join_through: TeamNinja
    many_to_many :mentors, Mentor, join_through: TeamMentor

    has_many :events, Event, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
