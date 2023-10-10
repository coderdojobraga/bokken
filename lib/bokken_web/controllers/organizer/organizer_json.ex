defmodule BokkenWeb.OrganizerJSON do
  def index(%{organizers: organizers}) do
    %{data: for(organizer <- organizers, do: data(organizer))}
  end

  def show(%{organizer: organizer}) do
    %{data: data(organizer)}
  end

  def data(organizer) do
    %{
      id: organizer.id,
      champion: organizer.champion,
      first_name: organizer.first_name,
      last_name: organizer.last_name
    }
  end
end
