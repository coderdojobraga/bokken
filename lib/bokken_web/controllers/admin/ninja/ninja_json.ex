defmodule BokkenWeb.Admin.NinjaJSON do
  alias Bokken.Accounts.Ninja
  alias Bokken.Uploaders.Avatar

  def index(%{ninjas: ninjas}) do
    %{data: for(ninja <- ninjas, do: data(ninja))}
  end

  def data(%Ninja{} = ninja) do
    %{
      id: ninja.id,
      photo: Avatar.url({ninja.photo, ninja}, :thumb),
      first_name: ninja.first_name,
      last_name: ninja.last_name,
      birthday: ninja.birthday,
      belt: ninja.belt,
      socials: ninja.socials,
      since: ninja.inserted_at
    }
    |> Map.put(:guardian, guardian(ninja))
  end

  defp guardian(ninja) do
    if Ecto.assoc_loaded?(ninja.guardian) do
      %{
        id: ninja.guardian.id,
        first_name: ninja.guardian.first_name,
        last_name: ninja.guardian.last_name
      }
    else
      %{}
    end
  end
end
