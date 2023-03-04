defmodule BokkenWeb.Admin.GuardianView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar

  def render("index.json", %{guardians: guardians}) do
    %{data: render_many(guardians, __MODULE__, "guardian.json")}
  end

  def render("guardian.json", %{guardian: guardian}) do
    %{
      id: guardian.id,
      photo: Avatar.url({guardian.photo, guardian}, :thumb),
      first_name: guardian.first_name,
      last_name: guardian.last_name,
      mobile: guardian.mobile,
      city: guardian.city,
      since: guardian.inserted_at
    }
    |> Map.merge(user_attrs(guardian))
  end

  defp user_attrs(guardian) do
    if Ecto.assoc_loaded?(guardian.user) do
      %{
        user_id: guardian.user.id,
        email: guardian.user.email,
        active: guardian.user.active,
        verified: guardian.user.verified,
        registered: guardian.user.registered
      }
    else
      %{}
    end
  end
end
