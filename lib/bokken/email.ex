defmodule Bokken.Email do
  @moduledoc """
  A module to build html and text emails.
  """
  use Bamboo.Phoenix, view: BokkenWeb.EmailView

  def verify_user_email(token, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    base_email()
    |> from("verify@coderdojobraga.org")
    |> to(email)
    |> subject("[CoderDojo Braga] Verifica a tua conta")
    |> put_header("Reply-To", "noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/confirm?token=" <> token)
    |> render(:verify)
  end

  defp base_email do
    new_email()
    |> from("geral@coderdojobraga.org")
    |> put_html_layout({BokkenWeb.LayoutView, "email.html"})
    |> put_text_layout({BokkenWeb.LayoutView, "email.text"})
  end
end
