defmodule Bokken.Ecto.PtMobile do
  @moduledoc """
  PT Phone number type with validation and formatting for Ecto.
  """

  use Ecto.Type

  def type, do: :string

  @doc """
  Transforms external data into a runtime format

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
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

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def dump("+351" <> mobile) do
    {:ok, "+351" <> mobile}
  end

  def dump(_mobile), do: :error

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def load("+351" <> mobile) do
    {:ok, "+351" <> mobile}
  end

  def load(_mobile), do: :error

  # Transforms a number into the standard format
  # ## Parameters
  #   - number: valis PT phone number in a list of strings (ex: ["9", "1", "6", "0", "6", "5", "5", "0", "0"])
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
