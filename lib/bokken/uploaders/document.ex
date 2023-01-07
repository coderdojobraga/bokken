defmodule Bokken.Uploaders.Document do
  @moduledoc """
  File is the document done by Ninja.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:snippets, :projects]
  @min_file_size 10_000
  @max_file_size 10_000_000

  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()

    size = file_size(file)

    cond do
      size < @min_file_size ->
        {:error, "File is too small. Minimum size is #{@min_file_size} bytes."}

      size > @max_file_size ->
        {:error, "File is too large. Maximum size is #{@max_file_size} bytes."}

      true ->
        {:ok, file}
    end
  end

  # Override the persisted filenames:
  def filename(_version, {file, _scope}) do
    Path.basename(file.file_name, Path.extname(file.file_name))
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) when is_nil(scope.lecture_id) do
    "uploads/projects/#{scope.user_id}"
  end

  def storage_dir(_version, {_file, scope}) do
    "uploads/snippets/#{scope.user_id}/#{scope.lecture_id}"
  end

  def file_size(%Waffle.File{} = file) do
    File.stat!(file.path)
    |> Map.get(:size)
  end
end
