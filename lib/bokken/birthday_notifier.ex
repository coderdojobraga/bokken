defmodule Bokken.BirthdayNotifier do
  @moduledoc """
  Executes a task periodically to notify Ninjas on their birthday.
  """

  alias Bokken.Accounts
  alias BokkenWeb.EventsEmails
  import Bokken.Events.EventAdmin

  def send_happy_birthday_ninjas do
    ninjas = Accounts.list_ninjas([:user])
    current_time = Date.utc_today()

    ninjas
    |> Enum.filter(fn ninja ->
      ninja.birthday.month == current_time.month && ninja.birthday.day == current_time.day &&
        not is_nil(ninja.user)
    end)
    |> Enum.map(fn ninja -> ninja.user end)
    |> send_email(fn user ->
      EventsEmails.ninja_birthday_email(user.ninja,
        to: Accounts.get_guardian_email_by_ninja(ninja: user)
      )
    end)
  end
end
