defmodule Bokken.Events.Lecture do
  @moduledoc """
  one on one lecture
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Events.{Event, LectureMentorAssistant}

  @required_fields [:ninja_id, :mentor_id, :event_id]
  @optional_fields [:notes, :summary]
  @association_fields [:assistant_mentors]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "lectures" do
    field :notes, :string
    field :summary, :string

    belongs_to :mentor, Mentor, foreign_key: :mentor_id
    belongs_to :event, Event, foreign_key: :event_id
    belongs_to :ninja, Ninja, foreign_key: :ninja_id

    many_to_many :assistant_mentors, Mentor, join_through: LectureMentorAssistant

    timestamps()
  end

  @doc false
  def changeset(lecture, attrs) do
    lecture
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:mentor)
    |> assoc_constraint(:event)
    |> assoc_constraint(:ninja)
  end
end
