defmodule Bokken.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Bokken.Repo

  use Bokken.Factories.{
    AccountFactory,
    BotsFactory,
    CurriculumFactory,
    EventFactory
  }
end
