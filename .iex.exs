import_file_if_available("~/.iex.exs")
import_file_if_available(".iex.local.exs")

import_if_available(Ecto.Changeset)
import_if_available(Ecto.Query)

alias Bokken.{
  Accounts,
  Accounts.Guardian,
  Accounts.Mentor,
  Accounts.Ninja,
  Accounts.Organizer,
  Accounts.User,
  Documents,
  Documents.File,
  Events,
  Events.Event,
  Events.Events,
  Events.Lecture,
  Events.Location,
  Events.Team,
  Gamification,
  Gamification.Badge,
  Repo
}
