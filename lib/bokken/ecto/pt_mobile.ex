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
  def cast(number) do
    case format(number) do
      {:ok, number} -> {:ok, number}
      {:error, message} -> {:error, message}
    end
  end

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def dump(number) do
    case format(number) do
      {:ok, number} -> {:ok, number}
      {:error, _message} -> :error
    end
  end

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def load(number) do
    case format(number) do
      {:ok, number} -> {:ok, number}
      {:error, _message} -> :error
    end
  end

  defp format(number) do
    {:ok, phone_number} = ExPhoneNumber.parse(number, "PT")

    if ExPhoneNumber.is_valid_number?(phone_number) do
      {:ok, ExPhoneNumber.format(phone_number, :e164)}
    else
      {:error, [message: "invalid PT phone number"]}
    end
  end
end
