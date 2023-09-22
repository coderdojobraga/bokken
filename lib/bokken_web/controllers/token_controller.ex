defmodule BokkenWeb.TokenController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.Token

  def index(conn, _params) do
    tokens = Accounts.list_tokens()

    conn
    |> put_status(:ok)
    |> render(:index, tokens: tokens)
  end

  def show(conn, %{"id" => id}) do
    token = Accounts.get_token!(id)

    conn
    |> put_status(:ok)
    |> render("show.json", token: token)
  end

  def create(conn, %{"token" => token_params}) do
    with {:ok, token} <- Accounts.create_token(token_params) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token)
    end
  end

  def update(conn, %{"id" => id, "token" => token_params}) do
    token = Accounts.get_token!(id)

    with {:ok, token} <- Accounts.update_token(token, token_params) do
      conn
      |> put_status(:ok)
      |> render("update.json", token: token)
    end
  end

  def delete(conn, %{"id" => id}) do
    token = Accounts.get_token!(id)

    with {:ok, %Token{}} <- Accounts.delete_token(token) do
      send_resp(conn, :no_content, "")
    end
  end
end
