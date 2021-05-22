defmodule Bokken.Accounts.Ninja do
  @moduledoc """
  A ninja is a dojo participant who is doing his training to learn and master programming.
  """
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset

  alias Bokken.Accounts.{Guardian, Social, User}
  alias Bokken.Events.{Lecture, Team, TeamNinja}
  alias Bokken.Gamification.{Badge, BadgeNinja}
  alias Bokken.Uploaders.Avatar

  @required_fields [:first_name, :last_name, :birthday, :guardian_id]
  @optional_fields [:notes, :user_id]
  @attachment_fields [:photo]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ninjas" do
    field :photo, Avatar.Type
    field :first_name, :string
    field :last_name, :string
    field :birthday, :date

    field :belt, Ecto.Enum,
      values: [nil, :white, :yellow, :blue, :green, :orange, :red, :purple, :black]

    field :notes, :string

    embeds_many :socials, Social

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :guardian, Guardian, foreign_key: :guardian_id

    many_to_many :badges, Badge, join_through: BadgeNinja
    many_to_many :teams, Team, join_through: TeamNinja

    has_many :lectures, Lecture, on_delete: :nothing

    timestamps()
  end

  @doc false
  def changeset(ninja, attrs) do
    ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:socials, with: &Social.changeset/2)
    |> cast_attachments(attrs, @attachment_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:guardian)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end
end
