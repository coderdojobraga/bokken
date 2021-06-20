defmodule Bokken.Events.Lecture do
  @moduledoc """
  one on one lecture
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Documents.File
  alias Bokken.Events.{Event, LectureMentorAssistant}

  @required_fields [:ninja_id, :event_id]
  @optional_fields [:mentor_id, :notes, :summary, :attendance]

  schema "lectures" do
    field :notes, :string
    field :summary, :string

    field :attendance, Ecto.Enum,
      values: [:both_present, :both_absent, :ninja_absent, :mentor_absent]

    belongs_to :mentor, Mentor, foreign_key: :mentor_id
    belongs_to :event, Event, foreign_key: :event_id
    belongs_to :ninja, Ninja, foreign_key: :ninja_id

    many_to_many :assistant_mentors, Mentor, join_through: LectureMentorAssistant
    has_many :files, File, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(lecture, attrs) do
    lecture
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:mentor)
    |> assoc_constraint(:event)
    |> unique_constraint(:ninja_event_constraint, name: :ninja_event_index)
  end
end
