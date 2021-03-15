defmodule Bokken.Accounts.Mentor do
  @moduledoc """
  A mentor is a user who helps ninjas to progress in their training.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:mobile, :trial, :user_id]
  @optional_fields [:birthday, :major]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "mentors" do
    field :mobile, :string
    field :birthday, :date
    field :major, :string
    field :trial, :boolean, default: true

    embeds_many :socials, Social do
      field :name, Ecto.Enum, values: [:scratch, :codewars, :github, :gitlab]
      field :username, :string
    end

    belongs_to :user, Bokken.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  @doc false
  def changeset(mentor, attrs) do
    mentor
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:socials, with: &social_changeset/2)
    |> validate_required(@required_fields)
  end

  defp social_changeset(social, params) do
    social
    |> cast(params, [:name, :username])
  end
end
