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
    Accounts.get_ninja!(ninja_id).user_id
    |> Accounts.get_user!([:files])
    |> Map.fetch!(:files)
  end

  def list_files(%{"mentor_id" => mentor_id}) do
    Accounts.get_mentor!(mentor_id).user_id
    |> Accounts.get_user!([:files])
    |> Map.fetch!(:files)
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
  def create_file(attrs \\ %{}) do
    if verify_total_size(attrs.document, attrs.user_id) > 6_000_000 do
      {:error, "You exceeded the maximum storage quota. Try to delete one or more files"}
    else
      %File{}
      |> File.changeset(attrs)
      |> Repo.insert()
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

  def verify_total_size(file, user_id) do
    user = Accounts.get_user!(user_id) |> Repo.preload(:files)

    total_size = Enum.reduce(user.files, 0, fn file, acc -> acc + File.file_size(file) end)
    total_size + File.file_size(file)
  end
end
