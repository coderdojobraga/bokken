defmodule BokkenWeb.ResetPasswordView do
  use BokkenWeb, :view

  def render("show.json", _) do
    %{
      data: %{
        info:
          "If your email adress exists in our database, you will receive a password reset link."
      }
    }
  end

  def render("ok.json", _) do
    %{data: %{info: "User password successfully updated."}}
  end

  def render("error.json", %{error: error}) do
    %{errors: error}
  end
end
