defmodule BokkenWeb.ResetPasswordController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Mailer
  alias BokkenWeb.AuthEmails

  @nil_attrs %{
    reset_password_token: nil,
    reset_token_sent_at: nil
  }

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "There is no such user with that email.")

      user ->
        user = Accounts.create_reset_password_token(user)

        AuthEmails.reset_password_email(user.reset_password_token, to: user.email)
        |> Mailer.deliver()

        conn
        |> put_status(:created)
        |> render("show.json", %{})
    end
  end

  def update(conn, %{"id" => token, "user" => params}) do
    case Accounts.get_user_by_token(token) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Token does not exist.")

      user ->
        if Accounts.token_expired?(user.reset_token_sent_at) do
          Accounts.update_reset_password_token(user, @nil_attrs)

          conn
          |> put_status(:not_found)
          |> render("error.json", error: "Token does not exist.")
        else
          case Accounts.reset_user_password(user, params, @nil_attrs) do
            {:ok, _user} ->
              conn
              |> put_status(:ok)
              |> render("ok.json", %{})

            {:error, _changeset} ->
              conn
              |> put_status(:bad_request)
              |> render("error.json", error: "Something went wrong.")
          end
        end
    end
  end
end
