defmodule Bokken.FileUploadStrategy do
  @moduledoc """
  Ex Machina strategy for file uploads with Waffle.
  cast_attachements is called before insert to set uploader's scope
  on fields with type name that maches "Uploader".
  """
  use Waffle.Ecto.Schema
  use ExMachina.Strategy, function_name: :insert_with_file_upload

  def handle_insert_with_file_upload(record, _opts) do
    fields =
      record.__struct__.__schema__(:fields)
      |> Enum.reject(fn field ->
        !String.match?(Atom.to_string(record.__struct__.__schema__(:type, field)), ~r/Uploader/)
      end)

    attrs =
      Enum.reduce(fields, %{}, fn field, acc -> Map.put(acc, field, Map.get(record, field)) end)

    data = cast_attachments(record, attrs, fields)

    Bokken.Repo.insert!(data)
  end
end
