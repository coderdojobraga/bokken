defmodule Bokken.Documents do
  @moduledoc """
  The Documents context.
  """

  import Ecto.Query, warn: false
  alias Bokken.Accounts
  alias Bokken.Documents.File
  alias Bokken.Repo

  @doc """
  Returns the list of files.

  ## Examples

      iex> list_files()
      [%File{}, ...]

  """
  @spec list_files(map()) :: list(File.t())
  def list_files(args \\ %{})

  def list_files(%{"ninja_id" => ninja_id}) do
    user_id = Accounts.get_ninja!(ninja_id).user_id

    if is_nil(user_id) do
      []
    else
      Accounts.get_user!(user_id, [:files])
      |> Map.fetch!(:files)
    end
  end

  def list_files(%{"mentor_id" => mentor_id}) do
    Accounts.get_mentor!(mentor_id).user_id
    |> Accounts.get_user!([:files])
    |> Map.fetch!(:files)
  end

  # Returns all the files of a guardian and its ninjas
  def list_files(%{"guardian_id" => guardian_id}) do
    guardian = Accounts.get_guardian!(guardian_id, [:ninjas])

    guardian.user_id
    |> Accounts.get_user!([:files])
    |> Map.fetch!(:files)
    |> Enum.concat(
      guardian.ninjas
      |> Enum.map(fn ninja ->
        list_files(%{"ninja_id" => ninja.id})
      end)
      |> Enum.flat_map(& &1)
    )
  end

  def list_files(_args) do
    File
    |> Repo.all()
  end

  @doc """
  Gets a single file.

  Raises `Ecto.NoResultsError` if the File does not exist.

  ## Examples

      iex> get_file!(123)
      %File{}

      iex> get_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_file!(id), do: Repo.get!(File, id)

  @doc """
  Creates a file.

  ## Examples

      iex> create_file(%{field: value})
      {:ok, %File{}}

      iex> create_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  alias Bokken.Accounts.User

  def create_file(attrs \\ %{}) do
    case Application.fetch_env!(:bokken, Bokken.Uploaders.Document)[:max_file_size] do
      nil ->
        {:error, "MAX_TOTAL_SIZE environment variable not defined"}

      max_total_size ->
        total_size = get_new_total_size(attrs["document"], attrs["user_id"])

        case total_size do
          total_size when total_size > max_total_size ->
            {:error, "You exceeded the maximum storage quota. Try to delete one or more files"}

          _ ->
            map = %{
              user_id: attrs["user_id"],
              document: attrs["document"],
              title: attrs["title"],
              description: attrs["description"]
            }

            create_file_with_user_update(map, total_size)
        end
    end
  end

  defp create_file_with_user_update(map, total_size) do
    Repo.transaction(fn ->
      changeset = File.changeset(%File{}, map)

      case Repo.insert(changeset) do
        {:ok, file} ->
          user_changeset =
            User.changeset(Accounts.get_user!(map[:user_id]), %{
              total_file_size: total_size
            })

          update_user_withchangeset(user_changeset, file)

        {:error, _} ->
          {:error, "Failed to create file"}
      end
    end)
  end

  defp update_user_withchangeset(user_changeset, file) do
    case Repo.update(user_changeset) do
      {:ok, _} -> {:ok, file}
      {:error, _} -> {:error, "Failed to update user's total file size"}
    end
  end

  @doc """
  Updates a file.

  ## Examples

      iex> update_file(file, %{field: new_value})
      {:ok, %File{}}

      iex> update_file(file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_file(%File{} = file, attrs) do
    file
    |> File.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a file.

  ## Examples

      iex> delete_file(file)
      {:ok, %File{}}

      iex> delete_file(file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_file(%File{} = file) do
    Repo.delete(file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking file changes.

  ## Examples

      iex> change_file(file)
      %Ecto.Changeset{data: %File{}}

  """
  def change_file(%File{} = file, attrs \\ %{}) do
    File.changeset(file, attrs)
  end

  def get_new_total_size(file, user_id) do
    user = Accounts.get_user!(user_id)

    user.total_file_size + File.file_size(file)
  end
end
