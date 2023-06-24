defmodule BokkenWeb.BadgeView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Emblem
  alias BokkenWeb.BadgeView

  def render("index.json", %{badges: badges}) do
    %{data: render_many(badges, BadgeView, "badge.json")}
  end

  def render("show.json", %{badge: badge}) do
    %{data: render_one(badge, BadgeView, "badge.json")}
  end

  def render("badge.json", %{badge: badge}) do
    %{
      id: badge.id,
      name: badge.name,
      description: badge.description,
      image: Emblem.url({badge.image, badge}, :original)
    }
  end
end
