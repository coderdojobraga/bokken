defmodule Bokken.Ecto.PtMobile do
  @moduledoc """
  PT Phone number type with validation and formatting for Ecto.
  """
  use Ecto.Type

  import BokkenWeb.Gettext

  @spec type :: :string
  def type, do: :string

  @doc """
  Transforms external data into a runtime format.

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format

  ## Examples

    iex> PtMobile.cast("+351 912 345 678")
    {:ok, "+351912345678"}

    iex> PtMobile.cast("929066855")
    {:ok, "+351929066855"}

    iex> PtMobile.cast("+351 939-066-855")
    {:ok, "+351939066855"}

    iex> PtMobile.cast("+351 979 066 855")
    {:error, [message: "número de telemóvel PT inválido"]}

    iex> Gettext.put_locale("en")
    iex> PtMobile.cast("+351 989 066 855")
    {:error, [message: "invalid PT phone number"]}

  """
  def cast(number), do: format(number)

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def dump(number), do: format(number) |> parse_result()

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def load(number), do: format(number) |> parse_result()

  defp format(number) do
    {:ok, phone_number} = ExPhoneNumber.parse(number, "PT")

    if ExPhoneNumber.is_valid_number?(phone_number) do
      {:ok, ExPhoneNumber.format(phone_number, :e164)}
    else
      {:error, [message: gettext("invalid PT phone number")]}
    end
  end

  defp parse_result({:ok, _number} = result), do: result
  defp parse_result({:error, _errors}), do: :error
end
