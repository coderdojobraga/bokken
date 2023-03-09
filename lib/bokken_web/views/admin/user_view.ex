defmodule BokkenWeb.Admin.UserView do
  use BokkenWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      active: user.active,
      verified: user.verified,
      registered: user.registered,
      since: user.inserted_at
    }
  end
end
