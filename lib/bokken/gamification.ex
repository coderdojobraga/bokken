defmodule Bokken.Gamification do
  @moduledoc """
  The Gamification context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Repo

  alias Bokken.Gamification.Badge

  @doc """
  Returns the list of badges.

  Takes a map with the following optional arguments:

    * `:limit` - The maximum number of badges to return.
    * `:ninja_id` - A ninja id to filter the results by.

  ## Examples

      iex> list_badges()
      [%Badge{}, ...]

  """
  @spec list_badges(map()) :: list(%Badge{})
  def list_badges(args \\ %{}) do
    Badge
    |> maybe_limit(args[:limit])
    |> filter_by_ninja(args[:ninja_id])
    |> Repo.all()
  end

  defp maybe_limit(query, nil), do: query

  defp maybe_limit(query, limit) do
    from c in query, limit: ^limit
  end

  defp filter_by_ninja(query, nil), do: query

  defp filter_by_ninja(query, ninja_id) do
    from c in query, where: ilike(c.ninja_id, ^ninja_id)
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
  def get_badge!(id), do: Repo.get!(Badge, id)

  @doc """
  Creates a badge.

  ## Examples

      iex> create_badge(%{field: value})
      {:ok, %Badge{}}

      iex> create_badge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_badge(attrs \\ %{}) do
    %Badge{}
    |> Badge.changeset(attrs)
    |> Repo.insert()
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
    |> Badge.changeset(attrs)
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
    Repo.delete(badge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking badge changes.

  ## Examples

      iex> change_badge(badge)
      %Ecto.Changeset{data: %Badge{}}

  """
  def change_badge(%Badge{} = badge, attrs \\ %{}) do
    Badge.changeset(badge, attrs)
  end

  alias Bokken.Gamification.BadgeNinja

  def give_badge(badge_id, ninja_id) do
    %BadgeNinja{}
    |> BadgeNinja.changeset(%{badge_id: badge_id, ninja_id: ninja_id})
    |> Repo.insert()
  end
end
