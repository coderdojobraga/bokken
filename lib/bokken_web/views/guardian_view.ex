defmodule BokkenWeb.GuardianView do
  use BokkenWeb, :view
  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.GuardianView

  def render("index.json", %{guardians: guardians}) do
    %{data: render_many(guardians, GuardianView, "guardian.json")}
  end

  def render("show.json", %{guardian: guardian}) do
    %{data: render_one(guardian, GuardianView, "guardian.json")}
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
  end
end
