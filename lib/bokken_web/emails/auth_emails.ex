defmodule BokkenWeb.AuthEmails do
  @moduledoc """
  A module to build auth related emails.
  """
  use Phoenix.Swoosh, view: BokkenWeb.EmailView, layout: {BokkenWeb.LayoutView, :email}

  def verify_user_email(token, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CoderDojo Braga", "verify@coderdojobraga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Verifica a tua conta")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/dashboard/confirm?token=" <> token)
    |> render_body(:verify)
  end

  def reset_password_email(token, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CoderDojo Braga", "noreply@coderdojo.braga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Instruções para repor a password")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/dashboard/reset?token=" <> token)
    |> render_body(:reset_password)
  end
end
