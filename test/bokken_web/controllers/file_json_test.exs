defmodule Bokken.FileJSONTest do
  use Bokken.DataCase

  import Bokken.Factory

  alias Bokken.Uploaders.Document
  alias BokkenWeb.FileJSON

  test "index" do
    files = build_list(5, :file)
    rendered_files = FileJSON.index(%{files: files})

    assert rendered_files == %{
             data: Enum.map(files, &FileJSON.data(&1))
           }
  end

  test "show" do
    file = build(:file)
    rendered_file = FileJSON.show(%{file: file})

    assert rendered_file == %{
             data: FileJSON.data(file)
           }
  end

  test "data" do
    file = build(:file)
    rendered_file = FileJSON.data(file)

    assert rendered_file == %{
             id: file.id,
             title: file.title,
             description: file.description,
             document: Document.url({file.document, file})
           }
  end
end
