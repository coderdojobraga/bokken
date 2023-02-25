defmodule BokkenWeb.ViewUtils do
  @moduledoc """
  A module with helper functions to display data in views
  """
  use Phoenix.HTML

  require Timex.Translator

  def frontend_url do
    Application.fetch_env!(:bokken, BokkenWeb.Endpoint)[:frontend_url]
  end

  @doc """
  Display a user's name

  ## Examples

      iex> display_name(%{"first_name" => "John", "last_name" => "Doe"})
      "John Doe"
  """
  def display_name(%{"first_name" => first_name, "last_name" => last_name}) do
    "#{first_name} #{last_name}"
  end

  @doc """
  Display a date in format "HH:MM"

  ## Examples

      iex> display_time(~U[2018-01-01 00:00:00Z])
      "00:00"

      iex> display_time(~U[2018-01-01 12:00:00Z])
      "12:00"

      iex> display_time(~U[2018-01-01 23:59:00Z])
      "23:59"
  """
  def display_time(datetime = %DateTime{}) do
    hour = two_characters(datetime.hour)
    minute = two_characters(datetime.minute)

    "#{hour}:#{minute}"
  end

  @doc """
  Display a date in a given locale

  ## Examples

      iex> display_date(~N[2018-01-01 00:00:00], "pt")
      "Segunda-feira, 1 de Janeiro de 2018"

      iex> display_date(~N[2018-01-01 00:00:00], "en")
      "Monday, January 1, 2018"
  """
  def display_date(datetime, locale \\ "pt")

  def display_date(datetime, "pt" = locale) do
    Timex.Translator.with_locale locale do
      Timex.format!(datetime, "{WDfull}, {D} de {Mfull} de {YYYY}")
    end
  end

  def display_date(datetime, "en" = locale) do
    Timex.Translator.with_locale locale do
      Timex.format!(datetime, "{WDfull}, {Mfull} {D}, {YYYY}")
    end
  end

  defp two_characters(number) do
    if number < 10 do
      "0#{number}"
    else
      number
    end
  end
end
