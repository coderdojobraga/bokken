defmodule Bokken.NinjaJSONTest do
  use Bokken.DataCase

  import Bokken.Factory
  alias Bokken.Uploaders.Avatar
  alias BokkenWeb.NinjaJSON

  describe "render as guardian" do
    setup do
      guardian = insert(:guardian)
      user = insert(:user, role: :guardian, guardian: guardian)
      ninja = insert(:ninja, guardian: guardian)

      {:ok, ninja: ninja, current_user: user}
    end

    test "show", %{ninja: ninja, current_user: user} do
      rendered_ninja = NinjaJSON.show(%{ninja: ninja, current_user: user})

      assert rendered_ninja ==
               %{
                 data: %{
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
               }
    end

    test "index", %{ninja: ninja, current_user: user} do
      ninjas = insert_list(5, :ninja, guardian: ninja.guardian)
      rendered_ninjas = NinjaJSON.index(%{ninjas: ninjas, current_user: user})

      assert 5 == Enum.count(rendered_ninjas[:data])
    end
  end

  describe "render as mentor" do
    setup do
      user = insert(:user, role: :mentor)
      ninja = insert(:ninja)
      {:ok, ninja: ninja, current_user: user}
    end

    test "show", %{ninja: ninja, current_user: user} do
      rendered_ninja = NinjaJSON.show(%{ninja: ninja, current_user: user})

      assert rendered_ninja ==
               %{
                 data: %{
                   id: ninja.id,
                   photo: Avatar.url({ninja.photo, ninja}),
                   first_name: ninja.first_name,
                   last_name: ninja.last_name,
                   belt: ninja.belt,
                   socials: ninja.socials,
                   since: ninja.inserted_at,
                   notes: nil,
                   guardian_id: ninja.guardian_id
                 }
               }
    end

    test "index", %{ninja: ninja, current_user: user} do
      ninjas = insert_list(5, :ninja, guardian: ninja.guardian)
      rendered_ninjas = NinjaJSON.index(%{ninjas: ninjas, current_user: user})

      assert 5 == Enum.count(rendered_ninjas[:data])
    end
  end
end
