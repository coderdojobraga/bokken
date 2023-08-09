defmodule Bokken.Uploaders.Emblem do
  @moduledoc """
  Emblem is the image for an Badge.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Bokken.Documents.File

  @versions [:original]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @max_file_size 1_000_000

  def validate({file, _}) do
    size = File.file_size(file)

    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1)) and size < @max_file_size
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/emblems/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "/images/default_badge.png"
  end
end
