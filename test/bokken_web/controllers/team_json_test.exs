defmodule Bokken.TeamJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias BokkenWeb.TeamJSON

  test "index" do
    teams = build_list(5, :team)
    rendered_teams = TeamJSON.index(%{teams: teams})

    assert rendered_teams == %{data: for(team <- teams, do: TeamJSON.data(team))}
  end

  test "show" do
    team = build(:team)
    rendered_team = TeamJSON.show(%{team: team})

    assert rendered_team == %{data: TeamJSON.data(team)}
  end

  test "data" do
    team = build(:team)
    rendered_team = TeamJSON.data(team)

    assert rendered_team == %{
             id: team.id,
             name: team.name,
             description: team.description
           }
  end
end
