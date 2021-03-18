defmodule BokkenWeb.AuthController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.User
  alias Bokken.Repo
  alias BokkenWeb.Authorization

  action_fallback BokkenWeb.FallbackController

  def sign_up(conn, user_info) do
    with {:ok, %User{} = user} <- Accounts.create_user(Map.drop(user_info, [:active, :verified])),
         {:ok, token, _claims} <-
           Authorization.encode_and_sign(user, %{role: user.role, active: user.active}) do
      render(conn, "token.json", %{jwt: token})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, _claims} =
          Authorization.encode_and_sign(user, %{role: user.role, active: user.active})

        render(conn, "token.json", %{jwt: token})

      {:error, reason} ->
        {:error, reason}
    end
  end

  def show(conn, _params) do
    user = Authorization.Plug.current_resource(conn) |> Repo.preload([:mentor, :guardian])
    render(conn, "me.json", user: user)
  end
end
