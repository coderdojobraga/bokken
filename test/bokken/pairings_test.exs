defmodule Bokken.PairingsTest do
  @moduledoc false
  use Bokken.DataCase

  import Bokken.Factory
  
  describe "pairings" do
    alias Bokken.Pairings

    defp forget(struct, field, cardinality \\ :one) do
      %{struct | 
        field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
      }
    end

    test "get_available_mentors/1 returns all available mentors for an event" do
      event = insert(:event)
      skill = insert(:skill)
      mentor = insert(:mentor, %{skills: [skill]})
               |> forget(:user)

      attrs = %{event: event, 
        is_available: true, 
        mentor: mentor
      }

      insert(:availability, attrs)

      result = Pairings.get_available_mentors(event.id)

      assert result == [mentor]
    end

    test "get_available_ninjas/1 returns all available ninjas for an event" do
      event = insert(:event)
      skill = insert(:skill)
      ninja = insert(:ninja, %{skills: [skill]})
               |> forget(:guardian)
               |> forget(:user)

      attrs = %{event: event, 
        accepted: true, 
        ninja: ninja
      }

      insert(:enrollment, attrs)

      result = Pairings.get_available_ninjas(event.id)

      assert result == [ninja]
    end

    test "create_pairings/1 returns a list of lectures for each pairing" do
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

      insert(:lecture, %{ninja: ninja1, mentor: mentor1})
      insert(:lecture, %{ninja: ninja2, mentor: mentor2})
      insert(:lecture, %{ninja: ninja3, mentor: mentor3})

      [{:ok, lecture_1}, {:ok, lecture_2}, {:ok, lecture_3}] = Pairings.create_pairings(event.id)

      assert lecture_1.mentor_id == mentor1.id
      assert lecture_2.mentor_id == mentor2.id
      assert lecture_3.mentor_id == mentor3.id

      assert lecture_1.ninja_id == ninja1.id
      assert lecture_2.ninja_id == ninja2.id
      assert lecture_3.ninja_id == ninja3.id
    end
  end
end
