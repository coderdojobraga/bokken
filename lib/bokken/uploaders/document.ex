defmodule Bokken.Uploaders.Document do
  @moduledoc """
  File is the document done by Ninja.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :project]

  # Override the persisted filenames:
  def filename(_version, {file, _scope}) do
    file.file_name
  end

  # Override the storage directory:
  def storage_dir(version, {_file, scope}) when is_map_key(scope, :ninja_id) do
    "uploads/files/#{version}/#{scope.ninja_id}/#{scope.lecture_id}"
  end

  def storage_dir(version, {_file, scope}) when is_map_key(scope, :mentor_id) do
    "uploads/files/#{version}/#{scope.mentor_id}/#{scope.lecture_id}"
  end
end
