defmodule Bokken.LocationJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.LocationJSON

  test "index" do
    locations = build_list(5, :location)
    rendered_locations = LocationJSON.index(%{locations: locations})

    assert rendered_locations == %{
             data: for(location <- locations, do: LocationJSON.data(location))
           }
  end

  test "show" do
    location = build(:location)
    rendered_location = LocationJSON.show(%{location: location})

    assert rendered_location == %{data: LocationJSON.data(location)}
  end

  test "data" do
    location = build(:location)
    rendered_location = LocationJSON.data(location)

    assert rendered_location == %{
             id: location.id,
             name: location.name,
             address: location.address
           }
  end
end
