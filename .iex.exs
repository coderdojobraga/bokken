import_file_if_available("~/.iex.exs")

import Ecto.Query

alias Bokken.{
  Accounts,
  Accounts.Guardian,
  Accounts.Mentor,
  Accounts.Ninja,
  Accounts.Organizer,
  Accounts.User,
  Events.Event,
  Events.Events,
  Events.Lecture,
  Events.Location,
  Events.Team,
  Gamification,
  Gamification.Badge,
  Repo
}
