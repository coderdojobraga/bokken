defmodule Bokken.Events.Location do
  @moduledoc """
  Location of an event
  """
  use Bokken.Schema

  alias Bokken.Events.Event

  @required_fields [:address, :name]
  @optional_fields []

  schema "locations" do
    field :address, :string
    field :name, :string

    has_many :events, Event, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
