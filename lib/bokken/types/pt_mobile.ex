defmodule Bokken.Types.Ecto.PtMobile do
  @moduledoc """
  PT Phone number type with validation and formatting for Ecto.
  """

  use Ecto.Type

  def type, do: :string

  # function to transform external data into a runtime format
  def cast("+351" <> number) do
    mobile =
      format(number)
      |> List.to_string()

    if is_nil(Regex.run(~r/9[12356]\d{7}/, mobile)) do
      {:error, [message: "número PT não válido"]}
    else
      {:ok, "+351" <> mobile}
    end
  end

  def cast(_number) do
    {:error, [message: "número PT não válido"]}
  end

  # when putting the phone number into the database this function
  # transforms the data into a specific format to be stored
  def dump("+351" <> mobile) do
    {:ok, "+351" <> mobile}
  end

  def dump(_mobile) do
    :error
  end

  # when loading data from the database, this function transforms the data
  # back to a runtime format
  def load("+351" <> mobile) do
    {:ok, "+351" <> mobile}
  end

  def load(_mobile) do
    :error
  end

  # when recieving a phone number from the front end, the number will process
  # through this function to transform it into a standard format
  # it returns a list of strings
  defp format([]), do: []

  defp format(number) when is_list(number) do
    [n | rest] = number
    <<v::utf8>> = n

    if v >= 48 and v <= 57 do
      [n | format(rest)]
    else
      format(rest)
    end
  end

  defp format(number) do
    number
    |> String.trim()
    |> String.graphemes()
    |> format()
  end
end
