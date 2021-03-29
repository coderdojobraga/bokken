defmodule Bokken.Accounts.Ninja do
  @moduledoc """
  A ninja is a dojo participant who is doing his training to learn and master programming.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:first_name, :last_name, :birthday, :guardian_id]
  @optional_fields [:photo, :notes, :user_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ninjas" do
    field :photo, :string
    field :first_name, :string
    field :last_name, :string
    field :birthday, :date

    field :belt, Ecto.Enum,
      values: [nil, :white, :yellow, :blue, :green, :orange, :red, :purple, :black]

    field :notes, :string

    embeds_many :socials, Bokken.Accounts.Social

    belongs_to :user, Bokken.Accounts.User, foreign_key: :user_id
    belongs_to :guardian, Bokken.Accounts.Guardian, foreign_key: :guardian_id

    many_to_many :badges, Bokken.Gamification.Badge, join_through: "bagdes_ninjas"

    timestamps()
  end

  @doc false
  def changeset(ninja, attrs) do
    ninja
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:socials, with: &social_changeset/2)
    |> validate_required(@required_fields)
    |> assoc_constraint(:guardian)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end

  defp social_changeset(social, params) do
    social
    |> cast(params, [:name, :username])
  end

  def changeset_update_badges(ninja, badge) do
    ninja
    |> cast(%{}, @required_fields)
    # associate badges to ninja
    |> put_assoc(:badges_ninja, badge)
  end
end
