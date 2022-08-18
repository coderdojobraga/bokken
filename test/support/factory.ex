defmodule Bokken.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Bokken.Repo

  use Bokken.Factories.AccountFactory
  use Bokken.Factories.CurriculumFactory
  use Bokken.Factories.GamificationFactory
  use Bokken.Factories.EventFactory
  use Bokken.Factories.BotsFactory

end
