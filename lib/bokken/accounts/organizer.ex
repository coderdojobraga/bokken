defmodule Bokken.Accounts.Organizer do
  @moduledoc """
  An organizer is a person who arranges the details of an event.
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Bokken.Accounts.{Mentor, User}

  @required_fields [:champion, :user_id]
  @optional_fields [:mentor_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "organizers" do
    field :champion, :boolean, default: false

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :mentor, Mentor, foreign_key: :mentor_id

    timestamps()
  end

  @doc false
  def changeset(organizer, attrs) do
    organizer
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:mentor)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
    |> unique_constraint(:mentor_id)
  end
end
