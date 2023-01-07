defmodule Bokken.Uploaders.Document do
  @moduledoc """
  File is the document done by Ninja.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @max_file_size 10_000_000

  def validate({file, _}) do
    size = file_size(file)

    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))
    |> check_file_size(size)
  end

  defp check_file_size(_, size) do
    if size > @max_file_size do
      {:error, "File size is too large"}
    else
      :ok
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

  defp file_size(%Waffle.File{} = file) do
    File.stat!(file.path)
    |> Map.get(:size)
  end
end
