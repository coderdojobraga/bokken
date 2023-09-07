defmodule BokkenWeb.GuardianView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.GuardianView

  def render("index.json", %{guardians: guardians, current_user: current_user}) do
    %{data: render_many(guardians, GuardianView, "guardian.json", current_user: current_user)}
  end

  def render("show.json", %{guardian: guardian, current_user: current_user}) do
    %{data: render_one(guardian, GuardianView, "guardian.json", current_user: current_user)}
  end

  def render("guardian.json", %{guardian: guardian, current_user: current_user}) do
    data(guardian)
    |> Map.merge(personal(guardian, current_user))
  end

  def data(guardian) do
    %{
      id: guardian.id,
      photo: Avatar.url({guardian.photo, guardian}, :thumb),
      first_name: guardian.first_name,
      last_name: guardian.last_name,
      since: guardian.inserted_at
    }
  end

  defp personal(guardian, current_user)
       when current_user.role == :organizer or current_user.id == guardian.id do
    %{
      mobile: guardian.mobile,
      city: guardian.city
    }
  end

  defp personal(_guardian, _current_user), do: %{}
end
