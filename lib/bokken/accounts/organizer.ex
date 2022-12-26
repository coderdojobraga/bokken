defmodule Bokken.Accounts.Organizer do
  @moduledoc """
  An organizer is a person who arranges the details of an event.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Mentor, User}

  @required_fields [:champion, :user_id, :first_name, :last_name]
  @optional_fields [:mentor_id]

  schema "organizers" do
    field :champion, :boolean, default: false
    field :first_name, :string
    field :last_name, :string
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
