defmodule Bokken.Uploaders.Document do
  @moduledoc """
  File is the document done by Ninja.
  """
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Bokken.Documents.File

  @extension_whitelist ~w(.txt .md .htm .html .css .js .ts .tsx .jsx .py .ipynb .c .cpp .h .hpp .cs .java .hs .doc .docx .ppt .pptx .xsl .xslx .png .jpg .svg .mp4 .mp3 .wav .zip .odf .odt .ods .xcf .sql)
  @max_file_size 4_000_000

  def validate({file, _}) do
    size = File.file_size(file)

    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1)) and size < @max_file_size
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
end
