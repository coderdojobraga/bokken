defmodule Bokken.Events.LectureMentorAssistant do
  @moduledoc """
  Lecture and Mentor Assistant join table
  """
  use Bokken.Schema

  alias Bokken.Accounts.Mentor
  alias Bokken.Events.Lecture

  @required_fields [:lecture_id, :mentor_id]
  @optional_fields []

  @primary_key false
  schema "lectures_mentors_assistants" do
    belongs_to :lecture, Lecture, type: :binary_id
    belongs_to :mentor, Mentor, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(lecture_mentor_assistant, attrs) do
    lecture_mentor_assistant
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:lecture)
    |> assoc_constraint(:mentor)
    |> unique_constraint([:lecture_id, :mentor_id], name: :lectures_mentors_pkey)
  end
end
