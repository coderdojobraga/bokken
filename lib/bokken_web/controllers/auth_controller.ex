defmodule BokkenWeb.AuthController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.User
  alias Bokken.Email
  alias Bokken.Mailer
  alias Bokken.Repo
  alias BokkenWeb.Authorization

  action_fallback BokkenWeb.FallbackController

  def show(conn, _params) do
    user =
      Authorization.Plug.current_resource(conn)
      |> Repo.preload([:mentor, :guardian, :ninja, :organizer])

    render(conn, "me.json", user: user)
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.authenticate_user(email, password) do
      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> render("me.json", %{user: user})
    end
  end

  def sign_out(conn, _) do
    conn
    |> Authorization.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  def sign_up(conn, user_info) do
    with {:ok, %User{} = user} <- Accounts.create_user(Map.drop(user_info, [:active, :verified])) do
      send_verification_token(user)

      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> put_status(:created)
      |> render("me.json", %{user: user})
    end
  end

  def verify(conn, %{"token" => token}) do
    with {:ok, %{"email" => email}} <- Authorization.decode_and_verify(token),
         {:ok, %User{} = user} <- Accounts.verify_user_email(email) do
      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> render("me.json", %{user: user})
    end
  end

  def resend(conn, _params) do
    user = Authorization.Plug.current_resource(conn)

    if user.verified do
      conn
      |> send_resp(:no_content, "")
    else
      send_verification_token(user)

      conn
      |> send_resp(:created, "")
    end
  end

  defp send_verification_token(user) do
    {:ok, token, _claims} =
      Authorization.encode_and_sign(user, %{email: user.email}, ttl: {15, :minute})

    Email.verify_user_email(token, to: user.email) |> Mailer.deliver_later!()
  end
end
