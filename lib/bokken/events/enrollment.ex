defmodule Bokken.Events.Enrollment do
  @moduledoc """
  An enrollment for an event of CoderDojo Braga
  """
  use Bokken.Schema

  alias Bokken.Accounts.Ninja
  alias Bokken.Events.Event

  @required_fields [:accepted, :ninja_id, :event_id]
  @optional_fields [:notes]

  schema "enrollments" do
    field :accepted, :boolean, default: false
    field :notes, :string

    belongs_to :event, Event
    belongs_to :ninja, Ninja

    timestamps()
  end

  @doc false
  def changeset(enrollment, attrs) do
    enrollment
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:event)
    |> assoc_constraint(:ninja)
  end
end
