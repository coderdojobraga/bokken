defmodule Bokken.Uploaders.Emblem do
  @moduledoc """
  Emblem is the image for an Badge.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
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
