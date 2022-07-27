defmodule Bokken.TypesTests do
  use ExUnit.Case

  describe "PT Phone number testing" do
    alias Bokken.Ecto.PtMobile

    @invalid_number_error [message: "número PT não válido"]

    def format([]), do: []

    def format(number) when is_list(number) do
      [n | rest] = number
      <<v::utf8>> = n

      if v >= 48 and v <= 57 do
        [n | format(rest)]
      else
        format(rest)
      end
    end

    def format(number) do
      number
      |> String.trim()
      |> String.graphemes()
      |> format()
    end

    test "cast\1 valid PT phone number 1" do
      "+351" <> number = "+351 919 066 855"
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast("+351 919 066 855") == {:ok, "+351" <> mobile}
    end

    test "cast\1 valid PT phone number 2" do
      "+351" <> number = "+351929066855"
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast("+351929066855") == {:ok, "+351" <> mobile}
    end

    test "cast\1 valid PT phone number 3" do
      "+351" <> number = "+351 939-066-855"
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast("+351 939-066-855") == {:ok, "+351" <> mobile}
    end

    test "cast\1 invalid PT phone number 1 - indicative number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("351 929 066 855")
    end

    test "cast\1 invalid PT phone number 2 - indicative number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("929 066 855")
    end

    test "cast\1 invalid PT phone number 3 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 979 066 855")
    end

    test "cast\1 invalid PT phone number 4 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 989 066 855")
    end

    test "cast\1 invalid PT phone number 5 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 999 066 855")
    end

    test "cast\1 invalid PT phone number 6 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast("+351 909 066 855")
    end
  end
end
