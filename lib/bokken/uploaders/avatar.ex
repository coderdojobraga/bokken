defmodule Bokken.Uploaders.Avatar do
  @moduledoc """
  Avatar is used for user photos.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :thumb]
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

  defp file_size(%Waffle.File{} = file) do
    File.stat!(file.path)
    |> Map.get(:size)
  end
end
