defmodule Bokken.Events.Event do
  @moduledoc """
  An enrollment for an event of Coderdojo
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Ninja}
  alias Bokken.Events.{Event}

  @required_fields [:when, :event, :ninja]
  @optional_fields [:accepted, :notes]

  schema "enrollments" do
    field :when, :utc_datetime
    field :accepted, :boolean
    field :notes, :string

    belongs_to :event, Event, foreign_key: :event_id
    belongs_to :ninja, Ninja, foreign_key: :ninja_id

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:event)
    |> assoc_constraint(:ninja)
  end
end
