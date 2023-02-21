defmodule BokkenWeb.CredentialController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Credential

  action_fallback BokkenWeb.FallbackController

  def show(conn, %{"id" => credential_id}) do
    credential = Accounts.get_credential!(%{"credential_id" => credential_id})

    conn
    |> put_status(:ok)
    |> render("show.json", credential: credential)
  end

  def update(conn, credential_params) do
    credential =
      Accounts.get_credential!(%{"credential_id" => credential_params["credential_id"]})

    if Credential.is_taken(credential) do
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", reason: "Credential already redeemed")
    else
      params =
        %{"ninja_id" => nil, "mentor_id" => nil, "organizer_id" => nil, "guardian_id" => nil}
        |> Map.merge(credential_params)

      case Accounts.update_credential(credential, params) do
        {:ok, %Credential{} = new_credential} ->
          conn
          |> put_status(:ok)
          |> render("show.json", credential: new_credential)

        {error, _reason} ->
          conn
          |> put_status(:bad_request)
      end
    end
  end

  def delete(conn, %{"id" => credential_id}) do
    credential = Accounts.get_credential!(%{"credential_id" => credential_id})

    case Accounts.update_credential(credential, %{
           ninja_id: nil,
           mentor_id: nil,
           guardian_id: nil,
           organizer_id: nil
         }) do
      {:ok, _new_credential} ->
        send_resp(conn, :no_content, "")
    end
  end
end
