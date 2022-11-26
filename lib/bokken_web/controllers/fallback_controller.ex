defmodule BokkenWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BokkenWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BokkenWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, reason}) when is_404(reason) do
    conn
    |> put_status(:not_found)
    |> put_view(BokkenWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, reason}) when is_401(reason) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BokkenWeb.ErrorView)
    |> render(:"401")
  end
end
