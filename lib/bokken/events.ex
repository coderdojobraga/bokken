defmodule Bokken.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false

  alias Bokken.Accounts
  alias Bokken.Events.Team
  alias Bokken.Repo

  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%Team{}, ...]

  """
  @spec list_teams(map()) :: list(%Team{})
  def list_teams(args \\ %{})

  def list_teams(%{"mentor_id" => mentor_id}) do
    mentor_id
    |> Accounts.get_mentor!([:teams])
    |> Map.fetch!(:teams)
  end

  def list_teams(%{"ninja_id" => ninja_id}) do
    ninja_id
    |> Accounts.get_ninja!([:teams])
    |> Map.fetch!(:teams)
  end

  def list_teams(_args) do
    Team
    |> Repo.all()
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
  def get_team!(id, preloads \\ []) do
    Repo.get!(Team, id) |> Repo.preload(preloads)
  end

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
end
