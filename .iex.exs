import_file_if_available("~/.iex.exs")

import Ecto.Query

alias Bokken.{
  Accounts,
  Accounts.Guardian,
  Accounts.Mentor,
  Accounts.Ninja,
  Accounts.User,
  Gamification,
  Gamification.Badge,
  Repo
}
