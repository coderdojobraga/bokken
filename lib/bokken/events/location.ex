defmodule Bokken.Events.Location do
  @moduledoc """
  Location of an event
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Bokken.Events.Event

  @required_fields [:address, :name]
  @optional_fields []

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "locations" do
    field :address, :string
    field :name, :string

    has_many :event, Event, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
