defmodule BokkenWeb.ResetPasswordController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Accounts.User
  alias Bokken.Repo
  alias Bokken.Mailer
  alias BokkenWeb.AuthEmails

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.get_user_by_email(email) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "There is no such user with that email.")

      user ->
        user = Accounts.reset_password_token(user)

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
        |> put_status(:bad_request)
        |> render("error.json", error: "Password reset token nonexistent.")

      user ->
        if Accounts.token_expired?(user.reset_token_sent_at) do
          User.password_token_changeset(user, %{
            reset_password_token: nil,
            reset_token_sent_at: nil
          })
          |> Repo.update!()

          conn
          |> put_status(:bad_request)
          |> render("error.json", error: "Password reset token expired.")
        else
          changeset = User.update_password_changeset(user, params)

          case Repo.update(changeset) do
            {:ok, _user} ->
              User.password_token_changeset(user, %{
                reset_password_token: nil,
                reset_token_sent_at: nil
              })
              |> Repo.update!()

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
