defmodule BokkenWeb.Admin.GuardianJSON do
  alias Bokken.Uploaders.Avatar

  def index(%{guardians: guardians}) do
    %{data: for(g <- guardians, do: guardian(g))}
  end

  def show(%{guardian: guardian}) do
    %{data: guardian(guardian)}
  end

  def guardian(guardian) do
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
