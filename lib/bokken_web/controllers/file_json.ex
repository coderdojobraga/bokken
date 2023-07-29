defmodule BokkenWeb.FileJSON do
  alias Bokken.Documents.File
  alias Bokken.Uploaders.Document

  def index(%{files: files}) do
    %{data: for(file <- files, do: data(file))}
  end

  def show(%{file: file}) do
    %{data: data(file)}
  end

  def data(%File{} = file) do
    type = if is_nil(file.lecture_id), do: :projects, else: :snippets

    %{
      id: file.id,
      title: file.title,
      description: file.description,
      document: Document.url({file.document, file}, type)
    }
  end
end
