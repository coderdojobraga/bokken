defmodule BokkenWeb.ResetPasswordController do
  use BokkenWeb, controller: "1.6"

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
        |> put_status(:created)
        |> render("show.json", %{})

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
    with {:ok, user} <- get_valid_user(token),
         {:ok, _user} <- Accounts.reset_user_password(user, params, @nil_attrs) do
      render(conn, "ok.json", %{})
    else
      {:error, :token_not_found} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: "Token does not exist.")

      {:error, :password_reset_error} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "Something went wrong.")
    end
  end

  defp get_valid_user(token) do
    case Accounts.get_user_by_token(token) do
      nil ->
        {:error, :token_not_found}

      user ->
        if Accounts.token_expired?(user.reset_token_sent_at) do
          Accounts.update_reset_password_token(user, @nil_attrs)
          {:error, :token_not_found}
        else
          {:ok, user}
        end
    end
  end
end
