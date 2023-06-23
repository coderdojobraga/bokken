defmodule BokkenWeb.FileView do
  use BokkenWeb, :view

  alias Bokken.Uploaders.Document
  alias BokkenWeb.FileView

  def render("index.json", %{files: files}) do
    %{data: render_many(files, FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, FileView, "file.json")}
  end

  def render("error.json", %{reason: reason}) do
    %{reason: reason}
  end

  def render("file.json", %{file: file}) do
    type = if is_nil(file.lecture_id), do: :projects, else: :snippets

    %{
      id: file.id,
      title: file.title,
      description: file.description,
      document: Document.url({file.document, file}, type)
    }
  end
end
