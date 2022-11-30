defmodule BokkenWeb.BotView do
  use BokkenWeb, :view

  alias BokkenWeb.BotView

  def render("index.json", %{bots: bots}) do
    %{data: render_many(bots, BotView, "bot.json")}
  end

  def render("show.json", %{bot: bot}) do
    render_one(bot, BotView, "bot.json")
  end

  def render("create.json", %{bot_id: bot_id, api_key: api_key}) do
    %{
      bot_id: bot_id,
      api_key: api_key
    }
  end

  def render("update.json", %{bot: bot}) do
    render_one(bot, BotView, "bot.json")
  end

  def render("bot.json", %{bot: bot}) do
    %{
      id: bot.id,
      name: bot.name
    }
  end
end
