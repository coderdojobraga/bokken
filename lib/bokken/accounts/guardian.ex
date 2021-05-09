defmodule Bokken.Accounts.Guardian do
  @moduledoc """
  A guardian is the ninja's legal responsible.
  """
  use Ecto.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset

  alias Bokken.Accounts.{Ninja, User}
  alias Bokken.Uploaders.Avatar

  @portuguese_cities Jason.decode!(File.read!("data/pt/cities.json"))

  @required_fields [:first_name, :last_name, :mobile, :user_id]
  @optional_fields [:city]
  @attachment_fields [:photo]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
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

  defp validate_city_name(changeset) do
    cityname = get_field(changeset, :city)

    if Enum.member?(@portuguese_cities, cityname) do
      changeset
    else
      add_error(changeset, :city, "invalid city")
    end
  end

  @doc false
  def changeset(guardian, attrs) do
    guardian
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, @attachment_fields)
    |> validate_required(@required_fields)
    |> validate_city_name()
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end
end
