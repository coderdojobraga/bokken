defmodule BokkenWeb.BotController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Bot

  defguard is_organizer(conn) when conn.assigns.current_user.role === :organizer

  def index(conn, _params) when is_organizer(conn) do
    with {:ok, bots} <- Accounts.list_bots() do
      conn
      |> put_status(:ok)
      |> render("index.json", bots: bots)
    end
  end

  def show(conn, %{id: id}) do
    bot = Accounts.get_bot!(id)

    conn
    |> put_status(:ok)
    |> render("show.json", bot: bot)
  end

  def create(conn, %{name: name}) when is_organizer(conn) do
    api_key = Faker.String.base64(32)

    with {:ok, bot} <- Accounts.create_bot(%{name: name, api_key: api_key}) do
      conn
      |> put_status(:created)
      |> render("create.json", api_key: api_key)
    end
  end

  def update(conn, %{id: id, bot: bot_params}) when is_organizer(conn) do
    bot = Accounts.get_bot!(id) 
    with {:ok, bot} <- Accounts.update_bot(bot, bot_params) do
      conn
      |> put_status(:ok)
      |> render("update.json", bot: bot)
    end
  end

  def delete(conn, %{id: id}) do
    bot = Accounts.get_bot!(id) 
    with {:ok, bot} <- Accounts.delete_bot(bot) do
      send_resp(conn, :no_content, "")
    end
  end
end
