defmodule BokkenWeb.OrganizerView do
  use BokkenWeb, :view
  alias BokkenWeb.OrganizerView

  def render("index.json", %{organizers: organizers}) do
    %{data: render_many(organizers, OrganizerView, "organizer.json")}
  end

  def render("show.json", %{organizer: organizer}) do
    %{data: render_one(organizer, OrganizerView, "organizer.json")}
  end

  def render("organizer.json", %{organizer: organizer}) do
    %{
      id: organizer.id,
      champion: organizer.champion
    }
  end
end
