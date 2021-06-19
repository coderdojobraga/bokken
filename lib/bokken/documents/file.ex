defmodule Bokken.Documents.File do
  @moduledoc """
  Files related to CoderDojo's Lectures
  """
  use Bokken.Schema
  use Waffle.Ecto.Schema

  alias Bokken.Accounts.User
  alias Bokken.Events.Lecture
  alias Bokken.Uploaders.Document

  @required_fields [:user_id]
  @optional_fields [:title, :description, :lecture_id]
  @attachment_fields [:document]
  schema "files" do
    field :title, :string
    field :description, :string
    field :document, Document.Type

    belongs_to :lecture, Lecture, foreign_key: :lecture_id
    belongs_to :user, User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def update_changeset(file, attrs) do
    file
    |> cast(attrs, @optional_fields -- [:lecture_id])
    |> cast_attachments(attrs, @attachment_fields)
    |> validate_required(@required_fields ++ @attachment_fields)
    |> assoc_constraint(:user)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, @attachment_fields)
    |> validate_required(@required_fields ++ @attachment_fields)
    |> assoc_constraint(:user)
  end
end
