defmodule Bokken.Accounts.Guardian do
  @moduledoc """
  A guardian is the ninja's legal responsible.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @portuguese_cities Jason.decode!(File.read!("data/pt/cities.json"))

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

    has_many :ninjas, Bokken.Accounts.Ninja

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
    |> validate_required(@required_fields)
    |> validate_city_name()
    |> assoc_constraint(:user)
    |> unique_constraint(:user_id)
  end
end
