defmodule Bokken.Events.Availability do
  @moduledoc """
  The availability of the mentors for an event of CoderDojo Braga
  """
  use Bokken.Schema

  alias Bokken.Accounts.Mentor
  alias Bokken.Events.Event

  @required_fields [:is_available, :mentor_id, :event_id]
  @optional_fields [:notes]

  schema "availabilities" do
    field :is_available, :boolean, default: false
    field :notes, :string

    belongs_to :event, Event
    belongs_to :mentor, Mentor

    timestamps()
  end

  @doc false
  def changeset(availability, attrs) do
    availability
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:event)
    |> assoc_constraint(:mentor)
  end
end
