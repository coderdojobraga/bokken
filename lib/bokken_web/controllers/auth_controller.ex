defmodule BokkenWeb.AuthController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.User
  alias Bokken.Repo
  alias BokkenWeb.Authorization

  action_fallback BokkenWeb.FallbackController

  def sign_up(conn, user_info) do
    with {:ok, %User{} = user} <- Accounts.create_user(Map.drop(user_info, [:active, :verified])) do
      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> render("me.json", %{user: user})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
        |> render("me.json", %{user: user})

      {:error, reason} ->
        {:error, reason}
    end
  end

  def sign_out(conn, _) do
    conn
    |> Authorization.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  def show(conn, _params) do
    user = Authorization.Plug.current_resource(conn) |> Repo.preload([:mentor, :guardian, :ninja])
    render(conn, "me.json", user: user)
  end
end
