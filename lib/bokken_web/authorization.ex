defmodule BokkenWeb.Authorization do
  @moduledoc """
  A authorization module providing functionality and the code for encoding and
  decoding our token's values.
  """
  use Guardian, otp_app: :bokken

  alias Bokken.Accounts

  def subject_for_token(user, _claims) do
    # You can use any value for the subject of your token. A unique `id` is a
    # good subject, a non-unique email address is a poor subject.
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(%{"sub" => id}) do
    # Here we'll look up our resource from the claims, the subject can be
    # found in the `"sub"` key. In `above subject_for_token/2` we returned
    # the resource id so here we'll rely on that to look it up.

    case Accounts.get_user(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
