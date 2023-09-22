defmodule BokkenWeb.NinjaJSON do

  alias Bokken.Accounts.Ninja

  def index(%{ninjas: ninjas, current_user: current_user}) do
    %{data: for(ninja <- ninjas, do: data(ninja, current_user))}
  end

  def show(%{ninja: ninja, current_user: current_user}) do
    %{data: data(ninja, current_user)}
  end

  def bonus(ninja: ninja, current_user: current_user) do
    data(ninja,current_user)
    |> Map.merge(personal(ninja, current_user))
    |> Map.merge(sensitive(ninja, current_user))
  end

  def data(%Ninja{} = ninja, _) do
    %{
      id: ninja.id,
      photo: ninja.photo,
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      birthday: ninja.birthday,
      belt: ninja.belt,
      notes: ninja.notes,
      guardian_id: ninja.guardian_id,
      badges: ninja.badges,
      teams: ninja.teams,
      events: ninja.events,
      user_id: ninja.user_id
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
     # %{skills: render_many(ninja.skills, SkillView, "skill.json")}

    else
      %{}
    end
  end
end
