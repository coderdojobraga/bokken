defmodule BokkenWeb.NinjaJSON do
  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.SkillJSON

  def index(%{ninjas: ninjas, current_user: current_user}) do
    %{data: for(ninja <- ninjas, do: data(ninja, current_user))}
  end

  def show(%{ninja: ninja, current_user: current_user}) do
    %{data: data(ninja, current_user)}
  end

  def data(ninja, current_user) do
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
    |> Map.merge(personal(ninja, current_user))
    |> Map.merge(sensitive(ninja, current_user))
    |> Map.merge(skills(ninja))
  end

  defp personal(ninja, current_user)
       when current_user.role in [:organizer, :guardian] or current_user.id == ninja.id do
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
      %{skills: for(skill <- ninja.skills, do: SkillJSON.data(skill))}
    else
      %{}
    end
  end
end
