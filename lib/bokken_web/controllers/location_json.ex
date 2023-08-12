defmodule BokkenWeb.LocationJSON do
  alias Bokken.Events.Location

  def index(%{locations: locations}) do
    %{data: for(location <- locations, do: data(location))}
  end

  def show(%{location: location}) do
    %{data: data(location)}
  end

  def data(%Location{} = location) do
    %{
      id: location.id,
      name: location.name,
      address: location.address
    }
  end
end
