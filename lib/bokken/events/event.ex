defmodule Bokken.Events.Event do
  @moduledoc """
  An event of CoderDojo
  """
  use Bokken.Schema

  alias Bokken.Events.{Lecture, Location, Team}

  @required_fields [:team_id, :location_id, :online, :start_time, :end_time]
  @optional_fields [:notes, :title]

  schema "events" do
    field :notes, :string
    field :online, :boolean
    field :title, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :location, Location, foreign_key: :location_id
    belongs_to :team, Team, foreign_key: :team_id

    has_many :lectures, Lecture, on_delete: :nothing

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
