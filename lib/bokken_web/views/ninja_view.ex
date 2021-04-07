defmodule BokkenWeb.NinjaView do
  use BokkenWeb, :view
  alias BokkenWeb.NinjaView

  def render("index.json", %{ninjas: ninjas}) do
    %{data: render_many(ninjas, NinjaView, "ninja.json")}
  end

  def render("show.json", %{ninja: ninja}) do
    %{data: render_one(ninja, NinjaView, "ninja.json")}
  end

  def render("ninja.json", %{ninja: ninja}) do
    %{
      id: ninja.id,
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      birthday: ninja.birthday,
      belt: ninja.belt,
      notes: ninja.notes,
      socials: ninja.socials
    }
  end
end
