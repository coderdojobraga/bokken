defmodule Bokken.Accounts.Ninja do
  @moduledoc """
  A ninja is a dojo participant who is doing his training to learn and master programming.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Guardian, Social, User}
  alias Bokken.Curriculum.{NinjaSkill, Skill}
  alias Bokken.Events.{Event, Lecture, Team, TeamNinja}
  alias Bokken.Gamification.{Badge, BadgeNinja}
  alias Bokken.Uploaders.Avatar

  @required_fields [:first_name, :last_name, :birthday, :guardian_id]
  @optional_fields [:notes, :user_id, :belt]
  @attachment_fields [:photo]

  schema "ninjas" do
    field :photo, Avatar.Type
    field :first_name, :string
    field :last_name, :string
    field :birthday, :date

    field :belt, Ecto.Enum,
      values: [nil, :white, :yellow, :blue, :green, :orange, :red, :purple, :black],
      default: nil

    field :notes, :string

    embeds_many :socials, Social

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :guardian, Guardian, foreign_key: :guardian_id

    many_to_many :badges, Badge, join_through: BadgeNinja
    many_to_many :teams, Team, join_through: TeamNinja
    many_to_many :events, Event, join_through: Lecture
    many_to_many :skills, Skill, join_through: NinjaSkill

    timestamps()
  end

  @doc false
  def changeset(ninja, attrs) do
    ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:socials, with: &Social.changeset/2)
    |> cast_attachments(attrs, @attachment_fields, allow_urls: true)
    |> validate_required(@required_fields)
    |> validate_birthday()
    |> assoc_constraint(:guardian)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end

  defp validate_birthday(
         %Ecto.Changeset{valid?: true, changes: %{birthday: birthday}} = changeset
       ) do
    lower_limit = Date.utc_today() |> Date.add(-(365 * 17))
    upper_limit = Date.utc_today() |> Date.add(-(365 * 6))

    if birthday <= lower_limit or birthday >= upper_limit do
      add_error(changeset, :birthdate, "Ninja's age should be between 6 and 17 years old")
    else
      changeset
    end
  end

  defp validate_birthday(changeset), do: changeset
end
