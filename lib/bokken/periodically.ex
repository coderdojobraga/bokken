defmodule Bokken.Periodically do
  use GenServer

  alias Bokken.Accounts
  alias BokkenWeb.EventsEmails
  import Bokken.Events.EventAdmin

  @one_day (24 * 60 * 60 * 1000)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    notify_ninja_birthday()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10000)
  end

  defp notify_ninja_birthday() do
    ninjas = Accounts.list_ninjas([:user])
    current_time = ~D[2008-11-25]

    ninjas
    |> Enum.filter(fn ninja -> (ninja.birthday.month == current_time.month) && (ninja.birthday.day == current_time.day) && not is_nil(ninja.user) end)
    |> Enum.map(fn ninja -> ninja.user end)
    # |> Enum.filter(fn ninja -> (Date.compare(ninja.birthday, current_time) == :eq) end)
    |> send_email(fn user -> EventsEmails.ninja_birthday_email(user.ninja, to: Accounts.get_guardian_email_by_ninja(ninja: user)) end)
  end
end
