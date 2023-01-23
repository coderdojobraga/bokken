defmodule Bokken.Uploaders.Emblem do
  @moduledoc """
  Emblem is the image for an Badge.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)
<<<<<<< HEAD
  @max_file_size 5_000_000
=======
  @max_file_size 50_000_000
>>>>>>> 76f82bd699ac13b44c2cf5eca0524417e9914414

  def validate({file, _}) do
    size = file_size(file)

    file.file_name
    |> Path.extname()
    |> String.downcase()
<<<<<<< HEAD
    |> then(&Enum.member?(@extension_whitelist, &1)) and size < @max_file_size
=======
    |> then(&Enum.member?(@extension_whitelist, &1)) and check_file_size(size)
  end

  defp check_file_size(size) do
    if size > @max_file_size do
      false
    else
      true
    end
>>>>>>> 76f82bd699ac13b44c2cf5eca0524417e9914414
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
    base_url() <> "/images/default_badge.png"
  end

  defp base_url do
    Application.fetch_env!(:waffle, :asset_host)
  end

  defp file_size(%Waffle.File{} = file) do
    File.stat!(file.path)
    |> Map.get(:size)
  end
end
