defmodule BokkenWeb.NinjaView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.{NinjaView, SkillView}

  def render("index.json", %{ninjas: ninjas, current_user: current_user}) do
    %{data: render_many(ninjas, NinjaView, "ninja.json", current_user: current_user)}
  end

  def render("show.json", %{ninja: ninja, current_user: current_user}) do
    %{data: render_one(ninja, NinjaView, "ninja.json", current_user: current_user)}
  end

  def render("ninja.json", %{ninja: ninja, current_user: current_user}) do
    data(ninja)
    |> Map.merge(personal(ninja, current_user))
    |> Map.merge(sensitive(ninja, current_user))
  end

  def data(ninja) do
    %{
      id: ninja.id,
      photo: Avatar.url({ninja.photo, ninja}, :thumb),
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      belt: ninja.belt,
      socials: ninja.socials,
      since: ninja.inserted_at,
      guardian_id: ninja.guardian_id
    }
    |> Map.merge(skills(ninja))
  end

  defp personal(ninja, current_user)
       when current_user.role == :organizer or current_user.id == ninja.id do
    %{
      birthday: ninja.birthday
    }
  end

  defp personal(_ninja, _current_user), do: %{}

  defp sensitive(ninja, current_user) when current_user.role in [:organizer, :mentor] do
    %{
      notes: ninja.notes
    }
  end

  defp sensitive(_ninja, _current_user), do: %{}

  defp skills(ninja) do
    if Ecto.assoc_loaded?(ninja.skills) do
      %{skills: render_many(ninja.skills, SkillView, "skill.json")}
    else
      %{}
    end
  end
end
