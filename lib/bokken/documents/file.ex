defmodule Bokken.Documents.File do
  @moduledoc """
  Files related to CoderDojo's Lectures
  """
  use Bokken.Schema
  use Waffle.Ecto.Schema

  alias Bokken.Accounts.{Mentor, Ninja}
  alias Bokken.Events.Lecture
  alias Bokken.Uploaders.Document

  @required_fields [:description]
  @optional_fields [:ninja_id, :mentor_id, :lecture_id]
  @attachment_fields [:document]
  schema "files" do
    field :description, :string
    field :document, Document.Type

    belongs_to :lecture, Lecture, foreign_key: :lecture_id
    belongs_to :mentor, Mentor, foreign_key: :mentor_id
    belongs_to :ninja, Ninja, foreign_key: :ninja_id

    timestamps()
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, @attachment_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:ninja)
    |> assoc_constraint(:mentor)
  end
end
