defmodule Bokken.Uploaders.Document do
  @moduledoc """
  File is the document done by Ninja.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:snippets, :projects]

  # Override the persisted filenames:
  def filename(_version, {file, _scope}) do
    Path.basename(file.file_name, Path.extname(file.file_name))
  end

  # Override the storage directory:
  def storage_dir(version, {_file, scope}) do
    "uploads/#{version}/#{scope.user_id}/#{scope.lecture_id}"
  end
end
