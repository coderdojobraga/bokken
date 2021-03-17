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
      birthday: ninja.birthday,
      belt: ninja.belt,
      notes: ninja.notes,
      social: ninja.social
    }
  end
end
