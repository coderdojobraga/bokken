defmodule Bokken.Cities.Citieslist do
  @moduledoc """
  List of cities.
  """
  @cities %{
    "Braga" => "Braga",
    "Guimarães" => "Guimarães",
    "Vieira do Minho" => "Vieira do Minho"
  }

  def get_city(name) do
    Map.fetch!(@cities, name)
  end

  def get_all_cities do
    Map.values(@cities)
  end
end
