defmodule BokkenWeb.BotController do
  use BokkenWeb, :controller

  alias Bokken.Accounts

  def create(conn, params) do

  end

  # def show(conn, %{"id" => discord_id}) do
  #   user = Accounts.get_user(discord_id)
  #          |> Repo.preload([:ninja])
    
  #   conn
  #   |> put_status(:ok)
  #   |> render("show.json", user: user)
  # end

  # def update(conn, %{"discord_id" => discord_id, "belt" => belt}) do
  #   user = Accounts.get_user(discord_id)
  #          |> Repo.preload([:ninja])

  #   ninja = Accounts.update_ninja(user.ninja, %{belt: String.to_atom(belt)})

  #   conn
  #   |> put_status(:ok) 
  #   |> render("update.json", %{ninja: discord_id})
  # end
end
