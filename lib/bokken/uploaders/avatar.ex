defmodule Bokken.Uploaders.Avatar do
  @moduledoc """
  Avatar is used for user photos.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
  @min_file_size 10_000
  @max_file_size 10_000_000

  # Whitelist file extensions:
  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))

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

  def file_size(%Waffle.File{} = file) do
    File.stat!(file.path)
    |> Map.get(:size)
  end
end
