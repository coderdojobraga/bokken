defmodule Bokken.Accounts.Guardian do
  @moduledoc """
  A guardian is the ninja's legal responsible.
  """

  use Ecto.Schema
  alias Bokken.Cities.Citieslist
  import Ecto.Changeset

  @required_fields [:first_name, :last_name, :mobile, :user_id]
  @optional_fields [:photo, :city]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "guardians" do
    field :first_name, :string
    field :last_name, :string

    field :mobile, :string
    field :city, :string
    field :photo, :string

    belongs_to :user, Bokken.Accounts.User, foreign_key: :user_id

    timestamps()
  end

  defp validate_city_name(changeset) do
    cityname = get_field(changeset, :city)

    if cityname == Citieslist.get_city(cityname) do
      changeset
    else
      {:error, "Invalid city"}
    end
  end

  @doc false
  def changeset(guardian, attrs) do
    guardian
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
    |> validate_city_name
  end
end