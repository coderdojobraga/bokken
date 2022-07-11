defmodule Bokken.Accounts.Guardian do
  @moduledoc """
  A guardian is the ninja's legal responsible.
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Ninja, User}
  alias Bokken.Uploaders.Avatar

  @portuguese_cities Jason.decode!(File.read!("data/pt/cities.json"))

  @required_fields [:first_name, :last_name, :mobile, :user_id]
  @optional_fields [:city]
  @attachment_fields [:photo]

  schema "guardians" do
    field :photo, Avatar.Type
    field :first_name, :string
    field :last_name, :string

    field :mobile, :string
    field :city, :string

    belongs_to :user, User, foreign_key: :user_id

    has_many :ninjas, Ninja

    timestamps()
  end

  @doc false
  def changeset(guardian, attrs) do
    guardian
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, @attachment_fields, allow_urls: true)
    |> validate_required(@required_fields)
    |> validate_inclusion(:city, @portuguese_cities)
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end
end
