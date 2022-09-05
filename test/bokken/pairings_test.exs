defmodule Bokken.PairingsTest do
  @moduledoc false
  use Bokken.DataCase

  alias Bokken.Accounts

  import Bokken.Factories.PairingsFactory

  describe "pairings" do
    alias Bokken.Accounts.Ninja

    test "test 1" do
      ninja = insert(:user)
      IO.inspect ninja
    end
  end
end
