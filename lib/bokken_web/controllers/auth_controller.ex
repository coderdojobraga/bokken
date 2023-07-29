defmodule BokkenWeb.AuthController do
  use BokkenWeb, controller: "1.6"

  alias Bokken.Accounts
  alias Bokken.Accounts.User
  alias Bokken.Authorization
  alias Bokken.Mailer
  alias BokkenWeb.AuthEmails

  action_fallback BokkenWeb.FallbackController

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, %User{} = user} <- Accounts.authenticate_user(email, password) do
      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> render("me.json", %{user: user})
    end
  end

  def sign_up(conn, user_info) do
    with {:ok, %User{} = user} <- Accounts.sign_up_user(user_info) do
      send_verification_token(user)

      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
      |> put_status(:created)
      |> render("me.json", %{user: user})
    end
  end

  def sign_out(conn, _) do
    conn
    |> Authorization.Plug.sign_out()
    |> send_resp(:no_content, "")
  end

  def show(conn, _params) do
    render(conn, "me.json", %{user: conn.assigns.current_user})
  end

  def create(conn, %{"user" => user_params}) do
    current_user = conn.assigns.current_user

    with {:ok, %User{} = user} <-
           Accounts.register_user(current_user, user_params) do
      conn
      |> put_status(:created)
      |> render("me.json", %{user: user})
    end
  end

  def create(conn, %{"ninja_id" => ninja_id, "user" => user_params}) when is_guardian(conn) do
    current_guardian = conn.assigns.current_user
    ninja = Accounts.get_ninja!(ninja_id, [:guardian])

    with true <- current_guardian.id == ninja.guardian.id,
         {:ok, %User{} = user} <- Accounts.create_account_for_ninja(ninja, user_params) do
      send_verification_token(user)

      conn
      |> put_status(:created)
      |> render("me.json", %{user: user})
    end
  end

  def update(conn, %{"user" => user_params}) when is_registered(conn) do
    current_user = conn.assigns.current_user

    with {:ok, %User{} = user} <- Accounts.edit_user(current_user, user_params, current_user.role) do
      render(conn, "me.json", %{user: user})
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
    current_user = conn.assigns.current_user

    if current_user.verified do
      conn
      |> send_resp(:no_content, "")
    else
      send_verification_token(current_user)

      conn
      |> send_resp(:created, "")
    end
  end

  defp send_verification_token(user) do
    {:ok, token, _claims} =
      Authorization.encode_and_sign(user, %{email: user.email}, ttl: {30, :minute})

    AuthEmails.verify_user_email(token, to: user.email) |> Mailer.deliver()
  end
end
