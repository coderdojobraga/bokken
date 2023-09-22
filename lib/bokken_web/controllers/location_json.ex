defmodule BokkenWeb.LocationJSON do


  def index(%{locations: locations}) do
    %{data: for(location <- locations, do: data(location))}
  end

  def show("show.json", %{location: location}) do
    %{data: data(location)}
  end

  def data( %{location: location}) do
    %{id: location.id, name: location.name, address: location.address}
  end
end
