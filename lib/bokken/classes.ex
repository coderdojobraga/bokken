defmodule Bokken.Classes do
  @moduledoc """
  The Classes context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Classes.Team

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  def list_teams do
    Repo.all(Team)
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the Team does not exist.

  ## Examples

      iex> get_team!(123)
      %Team{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team!(id), do: Repo.get!(Team, id)

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %Team{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team.

  ## Examples

      iex> delete_team(team)
      {:ok, %Team{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{data: %Team{}}

  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end


  alias Bokken.Classes.TeamNinja

  def add_ninja_to_team(team_id, ninja_id) do
    %TeamNinja{}
    |> TeamNinja.changeset(%{team_id: team_id, ninja_id: ninja_id})
    |> Repo.insert()
  end

  def remove_ninja_team(team_id, ninja_id) do
    query =
      from team_ninja in TeamNinja,
        where: team_ninja.team_id == ^team_id,
        where: team_ninja.ninja_id == ^ninja_id

    Repo.delete_all(query)
  end


  alias Bokken.Classes.TeamMentor

  def add_mentor_to_team(team_id, mentor_id) do
    %TeamMentor{}
    |> TeamMentor.changeset(%{team_id: team_id, mentor_id: mentor_id})
    |> Repo.insert()
  end

  def remove_mentor_team(team_id, mentor_id) do
    query =
      from team_mentor in TeamMentor,
        where: team_mentor.team_id == ^team_id,
        where: team_mentor.mentor_id == ^mentor_id

    Repo.delete_all(query)
  end

end
