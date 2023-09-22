defmodule BokkenWeb.TeamJSON do

    alias Bokken.Events.Team

  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  def show(%{team: team}) do
    %{data: data(team)}
  end

  def data(%Team{} = team) do
    %{id: team.id,
      name: team.name,
      description: team.description}
  end
end
