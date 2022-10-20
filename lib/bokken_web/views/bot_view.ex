defmodule BokkenWeb.BotView do 
  use BokkenWeb, :view
  
  def render("index.json", %{bots: bots}) do
    %{data: render_many(bots, BotView, "bot.json")}
  end

  def render("show.json", %{bot: bot}) do
    render_one(bot, BotView, "bot.json")
  end
  
  def render("create.json", %{api_key: api_key}) do
    %{
      api_key: api_key
    }
  end

  def update("update.json", %{bot: bot}) do
    render_one(bot, BotView, "bot.json")
  end
  
  def render("bot.json", %{bot: bot}) do
    %{
      id: bot.id,
      name: bot.name 
    }
  end
end
