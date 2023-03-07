defmodule Bokken.Authorization do
  @moduledoc """
  A authorization module providing functionality and the code for encoding and
  decoding our token's values.
  """
  use Guardian, otp_app: :bokken

  alias Bokken.Accounts

  def subject_for_token(%Accounts.User{} = user, _claims) do
    {:ok, "user:" <> to_string(user.id)}
  end

  def subject_for_token(%Accounts.Token{role: :bot} = token, _claims) do
    {:ok, "bot:" <> to_string(token.id)}
  end

  def resource_from_claims(%{"sub" => "user:" <> id}) do
    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(%{"sub" => "bot:" <> id}) do
    {:ok, Accounts.get_token!(id)}
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end
end
