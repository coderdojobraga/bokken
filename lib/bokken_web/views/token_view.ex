defmodule BokkenWeb.TokenView do
  use BokkenWeb, :view

  alias BokkenWeb.TokenView

  def render("index.json", %{tokens: tokens}) do
    %{data: render_many(tokens, TokenView, "token.json")}
  end

  def render("show.json", %{token: token}) do
    render_one(token, TokenView, "token.json")
  end

  def render("create.json", %{token: token}) do
    render_one(token, TokenView, "token.json")
  end

  def render("update.json", %{token: token}) do
    render_one(token, TokenView, "token.json")
  end

  def render("token.json", %{token: token}) do
    %{
      id: token.id,
      name: token.name,
      description: token.description,
      jwt: token.api_key,
      role: token.role,
      created_at: token.inserted_at
    }
  end
end
