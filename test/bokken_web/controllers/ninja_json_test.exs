defmodule Bokken.NinjaJSONTest do
  use Bokken.DataCase

  import Bokken.Factory
  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.NinjaJSON

  test "data" do
    ninja = build(:ninja)
    rendered_ninja = NinjaJSON.data(ninja)

    assert rendered_ninja == %{
             id: ninja.id,
             photo: Avatar.url({ninja.photo, ninja}),
             first_name: ninja.first_name,
             last_name: ninja.last_name,
             belt: ninja.belt,
             socials: ninja.socials,
             since: ninja.inserted_at,
             birthday: ninja.birthday,
             guardian_id: ninja.guardian_id
           }
  end

  test "show" do
    ninja = build(:ninja)
    rendered_ninja = NinjaJSON.show(%{ninja: ninja})

    assert rendered_ninja == %{
             data: NinjaJSON.data(ninja)
           }
  end

  test "index" do
    ninjas = build_list(5, :ninja)
    rendered_ninjas = NinjaJSON.index(%{ninjas: ninjas})

    assert rendered_ninjas == %{
             data: Enum.map(ninjas, &NinjaJSON.data(&1))
           }
  end
end
