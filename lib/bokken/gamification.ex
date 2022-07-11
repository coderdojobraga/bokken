defmodule Bokken.Gamification do
  @moduledoc """
  The Gamification context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Accounts
  alias Bokken.Gamification.Badge
  alias Bokken.Gamification.BadgeNinja
  alias Bokken.Uploaders.Emblem

  @doc """
  Returns the list of badges.

  Takes a map with the following optional arguments:

    * `:ninja_id` - A ninja id to filter the results by.

  ## Examples

      iex> list_badges()
      [%Badge{}, ...]

  """
  @spec list_badges(map()) :: list(Badge.t())
  def list_badges(args \\ %{})

  def list_badges(%{"ninja_id" => ninja_id}) do
    ninja_id
    |> Accounts.get_ninja!([:badges])
    |> Map.fetch!(:badges)
  end

  def list_badges(_args) do
    Badge
    |> Repo.all()
  end

  @doc """
  Gets a single badge.

  Raises `Ecto.NoResultsError` if the Badge does not exist.

  ## Examples

      iex> get_badge!(123)
      %Badge{}

      iex> get_badge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_badge!(id, preloads \\ []) do
    Repo.get!(Badge, id) |> Repo.preload(preloads)
  end

  @doc """
  Creates a badge.

  ## Examples

      iex> create_badge(%{field: value})
      {:ok, %Badge{}}

      iex> create_badge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_badge(attrs \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:badge, Badge.changeset(%Badge{}, attrs))
      |> Ecto.Multi.update(:image, &Badge.image_changeset(&1.badge, attrs))
      |> Repo.transaction()

    case transaction do
      {:ok, %{badge: badge, image: badge_with_image}} ->
        {:ok, %{badge | image: badge_with_image.image}}

      {:error, _transation, errors, _changes_so_far} ->
        {:error, errors}
    end
  end

  @doc """
  Updates a badge.

  ## Examples

      iex> update_badge(badge, %{field: new_value})
      {:ok, %Badge{}}

      iex> update_badge(badge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_badge(%Badge{} = badge, attrs) do
    badge
    |> change_badge(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a badge.

  ## Examples

      iex> delete_badge(badge)
      {:ok, %Badge{}}

      iex> delete_badge(badge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_badge(%Badge{} = badge) do
    Emblem.delete({badge.image, badge})
    Repo.delete(badge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking badge changes.

  ## Examples

      iex> change_badge(badge)
      %Ecto.Changeset{data: %Badge{}}

  """
  def change_badge(%Badge{} = badge, attrs \\ %{}) do
    badge
    |> Badge.changeset(attrs)
    |> Badge.image_changeset(attrs)
  end

  alias Bokken.Gamification.BadgeNinja

  def give_badge(badge_id, ninja_id) do
    %BadgeNinja{}
    |> BadgeNinja.changeset(%{badge_id: badge_id, ninja_id: ninja_id})
    |> Repo.insert()
  end

  def remove_badge(badge_id, ninja_id) do
    query =
      from(bn in BadgeNinja,
        where: bn.badge_id == ^badge_id,
        where: bn.ninja_id == ^ninja_id
      )

    Repo.delete_all(query)
  end
end
