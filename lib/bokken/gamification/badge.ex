defmodule Bokken.Gamification.Badge do
  @moduledoc """
  Badges are awards earned by ninjas for conquering challenges and finishing
  projects.
  """
  use Bokken.Schema

  alias Bokken.Accounts.Ninja
  alias Bokken.Gamification.BadgeNinja
  alias Bokken.Uploaders.Emblem

  @required_fields [:name]
  @optional_fields [:description]

  schema "badges" do
    field :name, :string
    field :description, :string
    field :image, Emblem.Type

    many_to_many :ninjas, Ninja, join_through: BadgeNinja

    timestamps()
  end

  @doc false
  def image_changeset(badge, attrs) do
    badge
    |> cast_attachments(attrs, [:image], allow_urls: true)
  end

  @doc false
  def changeset(badge, attrs) do
    badge
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
