defmodule BokkenWeb.EventsEmails do
  @moduledoc """
  A module to build event related emails.
  """
  use Phoenix.Swoosh, view: BokkenWeb.EmailView, layout: {BokkenWeb.LayoutView, :email}

  def event_reminder_email(user, event) do
    case user.role do
      :guardian -> guardian_event_reminder_email(event, to: user.email)
      :mentor -> mentor_event_reminder_email(event, to: user.email)
    end
  end

  def event_selected_mentor_email(event, lecture, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CoderDojo Braga", "noreply@coderdojobraga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Ninja da próxima sessão")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/event/" <> event.id)
    |> assign(:event, event)
    |> assign(:lecture, lecture)
    |> render_body(:mentor_event_selected)
  end

  def event_selected_ninja_email(event, lecture, to: email) do
    new()
    |> from({"CoderDojo Braga", "noreply@coderdojobraga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Inscrição aceite para a próxima sessão")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:event, event)
    |> assign(:lecture, lecture)
    |> render_body(:ninja_event_selected)
  end

  def guardian_event_reminder_email(event, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CoderDojo Braga", "noreply@coderdojobraga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Inscreva os seus ninjas na próxima sessão")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/event/" <> event.id)
    |> assign(:event, event)
    |> render_body(:guardian_event_reminder)
  end

  def mentor_event_reminder_email(event, to: email) do
    frontend_url = Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CoderDojo Braga", "noreply@coderdojobraga.org"})
    |> to(email)
    |> subject("[CoderDojo Braga] Inscreve-te na próxima sessão")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/event/" <> event.id)
    |> assign(:event, event)
    |> render_body(:mentor_event_reminder)
  end
end
