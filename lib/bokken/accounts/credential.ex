defmodule Bokken.Accounts.Credential do
  @moduledoc """
  A credential (QR Code) the uniquely identifies someone
  """
  use Bokken.Schema

  alias Bokken.Accounts.{Guardian, Mentor, Ninja, Organizer}
  alias Bokken.Documents.File

  @roles [:ninja, :guardian, :mentor, :organizer]
  @fkeys [:ninja_id, :guardian_id, :organizer_id, :mentor_id]
  schema "credentials" do
    belongs_to :guardian, Guardian
    belongs_to :mentor, Mentor
    belongs_to :ninja, Ninja
    belongs_to :organizer, Organizer

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @fkeys)
    |> validate_user_information()
  end

  def is_taken(credential) do
    credential.mentor_id != nil or credential.ninja_id != nil or credential.organizer_id != nil or
      credential.guardian_id != nil
  end

  defp validate_user_information(changeset) do
    case changeset.valid? do
      true ->
        set_fields = Enum.filter(@fkeys, fn field -> get_field(changeset, field) != nil end)

        if length(set_fields) <= 1 do
          changeset
        else
          add_error(
            changeset,
            List.first(set_fields),
            "Credential must be linked exclusively to one person"
          )
        end

      _ ->
        changeset
    end
  end
end
