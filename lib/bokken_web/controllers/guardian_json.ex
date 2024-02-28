defmodule BokkenWeb.GuardianJSON do
  alias Bokken.Uploaders.Avatar

  def index(%{guardians: guardians, current_user: current_user}) do
    %{data: for(g <- guardians, do: data(g, current_user))}
  end

  def show(%{guardian: guardian, current_user: current_user}) do
    %{data: data(guardian, current_user)}
  end

  def data(guardian, current_user) do
    guardian(guardian)
    |> Map.merge(personal(guardian, current_user))
  end

  defp guardian(guardian) do
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
