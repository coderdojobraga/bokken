defmodule Bokken.Uploaders.Avatar do
  @moduledoc false
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert,
     "-strip -thumbnail 250x250^ -gravity center -background none -extent 250x250 -format png",
     :png}
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    "uploads/avatars/#{scope.user_id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, scope) do
    "https://robohash.org/#{scope.first_name}-#{scope.last_name}"
  end
end
