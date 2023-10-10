defmodule Bokken.OrganizerJSONTest do
  use Bokken.DataCase

  import Bokken.Factory
  alias BokkenWeb.OrganizerJSON

  test "data" do
    organizer = build(:organizer)
    rendered_organizer = OrganizerJSON.data(organizer)

    assert rendered_organizer == %{
             id: organizer.id,
             champion: organizer.champion,
             first_name: organizer.first_name,
             last_name: organizer.last_name
           }
  end

  test "show" do
    organizer = build(:organizer)
    rendered_organizer = OrganizerJSON.show(%{organizer: organizer})

    assert rendered_organizer == %{
             data: OrganizerJSON.data(organizer)
           }
  end

  test "index" do
    organizers = build_list(5, :organizer)
    rendered_organizers = OrganizerJSON.index(%{organizers: organizers})

    assert rendered_organizers == %{
             data: Enum.map(organizers, &OrganizerJSON.data(&1))
           }
  end
end
