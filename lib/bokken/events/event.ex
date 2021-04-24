defmodule Bokken.Events.Event do
  @moduledoc """
  An event of CoderDojo
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bokken.Events.{Location, Team}

  @required_fields [:team_id, :location_id, :online]
  @optional_fields [:notes, :title]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :notes, :string
    field :online, :boolean
    field :title, :string

    belongs_to :location, Location, foreign_key: :location_id
    belongs_to :team, Team, foreign_key: :team_id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:team)
    |> assoc_constraint(:location)
  end
end
