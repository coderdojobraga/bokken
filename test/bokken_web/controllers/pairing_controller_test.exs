defmodule BokkenWeb.PairingControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  describe "create" do
    setup [:register_and_log_in_organizer]

    test "create pairings for an event", %{conn: conn} do
      event = insert(:event)

      skill1 = insert(:skill)
      skill2 = insert(:skill)
      skill3 = insert(:skill)

      ninja1 = insert(:ninja, %{skills: [skill1, skill2]})
      ninja2 = insert(:ninja, %{skills: [skill2, skill3]})
      ninja3 = insert(:ninja, %{skills: [skill1, skill3]})

      mentor1 = insert(:mentor, %{skills: [skill1, skill2]})
      mentor2 = insert(:mentor, %{skills: [skill2, skill3]})
      mentor3 = insert(:mentor, %{skills: [skill1, skill3]})

      insert(:availability, %{mentor: mentor1, event: event, is_available: true})
      insert(:availability, %{mentor: mentor2, event: event, is_available: true})
      insert(:availability, %{mentor: mentor3, event: event, is_available: true})

      insert(:enrollment, %{ninja: ninja1, event: event, accepted: true})
      insert(:enrollment, %{ninja: ninja2, event: event, accepted: true})
      insert(:enrollment, %{ninja: ninja3, event: event, accepted: true})

      conn = post(conn, Routes.event_pairing_path(conn, :create, event.id))
      assert Enum.count(json_response(conn, 201)["data"]) == 3
    end
  end

  describe "index" do
    setup [:register_and_log_in_organizer]

    test "list all pairings for an event", %{conn: conn} do
      event = insert(:event)

      insert_list(3, :lecture, %{event: event})

      conn = get(conn, Routes.event_pairing_path(conn, :index, event.id))
      assert Enum.count(json_response(conn, 200)["data"]) == 3
    end
  end
end
