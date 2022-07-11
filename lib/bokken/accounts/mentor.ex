defmodule Bokken.Accounts.Mentor do
  @moduledoc """
  A mentor is a user who helps ninjas to progress in their training.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Organizer, Social, User}
  alias Bokken.Events.{Event, Lecture, LectureMentorAssistant, Team, TeamMentor}
  alias Bokken.Uploaders.Avatar

  @required_fields [:first_name, :last_name, :mobile, :user_id]
  @optional_fields [:birthday, :major, :trial]

  schema "mentors" do
    field :photo, Avatar.Type
    field :first_name, :string
    field :last_name, :string

    field :mobile, :string

    field :birthday, :date
    field :major, :string

    field :trial, :boolean, default: true

    embeds_many :socials, Social

    belongs_to :user, User, foreign_key: :user_id

    many_to_many :teams, Team, join_through: TeamMentor
    many_to_many :events, Event, join_through: Lecture

    many_to_many :lectures, Lecture, join_through: LectureMentorAssistant

    has_one :organizer, Organizer, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(mentor, attrs) do
    mentor
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:socials, with: &Social.changeset/2)
    |> cast_attachments(attrs, [:photo], allow_urls: true)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end
end
