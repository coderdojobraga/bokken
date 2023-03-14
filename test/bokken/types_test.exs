defmodule Bokken.TypesTests do
  use ExUnit.Case, async: true

  describe "PT Phone number testing" do
    alias Bokken.Ecto.PtMobile

    @invalid_number_error [message: "invalid PT phone number"]

    test "cast\1 valid PT phone number 1" do
      assert {:ok, "+351919066855"} = PtMobile.cast("+351 919 066 855")
    end

    test "cast\1 valid PT phone number 2" do
      assert {:ok, "+351929066855"} = PtMobile.cast("+351929066855")
    end

    test "cast\1 valid PT phone number 3" do
      assert {:ok, "+351939066855"} = PtMobile.cast("+351 939-066-855")
    end

    test "cast\1 invalid PT phone number 1 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 979 066 855")
    end

    test "cast\1 invalid PT phone number 2 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 989 066 855")
    end

    test "cast\1 invalid PT phone number 3 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 999 066 855")
    end

    test "cast\1 invalid PT phone number 4 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 909 066 855")
    end
  end
end
