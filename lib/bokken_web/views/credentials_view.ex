defmodule BokkenWeb.CredentialsView do
  use BokkenWeb, :view

  alias BokkenWeb.CredentialsView

  def render("show.json", %{credential: credential}) do
    render_one(credential, CredentialView, "credential.json")
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("credential.json", %{credential: credential}) do
    case credential do
      %{id: id, ninja_id: ninja_id} -> %{id: id, ninja_id: ninja_id}
      %{id: id, mentor_id: mentor_id} -> %{id: id, mentor_id: mentor_id}
      %{id: id, organizer_id: organizer_id} -> %{id: id, organizer_id: organizer_id}
      %{id: id, guardian_id: guardian_id} -> %{id: id, guardian_id: guardian_id}
    end
  end
end
