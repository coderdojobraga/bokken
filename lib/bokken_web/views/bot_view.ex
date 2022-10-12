defmodule BokkenWeb.BotView do 
  use BokkenWeb, :view
  
  def render("show.json", %{user: user}) do
    render_one(user, BotView, "user.json")
  end

  def update("update.json", %{ninja: ninja}) do
    render_one(ninja, BotView, "ninja.json")
  end
  
  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      discord_id: user.discord_id,
      role: user.role
    }
  end

  def render("ninja.json", %{ninja: ninja}) do
    %{
      ninja_id: ninja.id,
      belt: ninja.belt 
    }
  end
end
