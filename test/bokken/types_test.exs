defmodule Bokken.TypesTests do
  use ExUnit.Case

  describe "PT Phone number testing" do
    alias Bokken.Types.Ecto.PtMobile

    @valid_number1 "+351 919 066 855"
    @valid_number2 "+351929066855"
    @valid_number3 "+351 939-066-855"

    @invalid_number1 "351 929 066 855"
    @invalid_number2 "929066855"
    @invalid_number3 "+351 979-066-855"
    @invalid_number4 "+351 989 066 855"
    @invalid_number5 "+351 999-066-855"
    @invalid_number6 "+351 909 066 855"

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
      "+351" <> number = @valid_number1
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast(@valid_number1) == {:ok, "+351" <> mobile}
    end

    test "cast\1 valid PT phone number 2" do
      "+351" <> number = @valid_number2
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast(@valid_number2) == {:ok, "+351" <> mobile}
    end

    test "cast\1 valid PT phone number 3" do
      "+351" <> number = @valid_number3
      mobile = format(number) |> List.to_string()

      assert PtMobile.cast(@valid_number3) == {:ok, "+351" <> mobile}
    end

    test "cast\1 invalid PT phone number 1 - indicative number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number1)
    end

    test "cast\1 invalid PT phone number 2 - indicative number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number2)
    end

    test "cast\1 invalid PT phone number 3 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number3)
    end

    test "cast\1 invalid PT phone number 4 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number4)
    end

    test "cast\1 invalid PT phone number 5 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number5)
    end

    test "cast\1 invalid PT phone number 6 - wrong number error" do
      assert {:error, @invalid_number_error} = PtMobile.cast(@invalid_number6)
    end
  end
end
