defmodule BokkenWeb.CredentialView do
  use BokkenWeb, :view

  alias BokkenWeb.CredentialView

  def render("show.json", %{credential: credential}) do
    render_one(credential, CredentialView, "credential.json")
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("credential.json", %{credential: credential}) do
    cond do
      credential.ninja_id != nil ->
        %{id: credential.id, ninja_id: credential.ninja_id}

      credential.mentor_id != nil ->
        %{id: credential.id, mentor_id: credential.mentor_id}

      credential.organizer_id != nil ->
        %{id: credential.id, organizer_id: credential.organizer_id}

      credential.guardian_id != nil ->
        %{id: credential.id, guardian_id: credential.guardian_id}

      true ->
        %{id: credential.id}
    end
  end
end
