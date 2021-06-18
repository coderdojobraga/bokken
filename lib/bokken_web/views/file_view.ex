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

  def render("file.json", %{file: file}) do
    title = file.document.file_name
    doc = Document.url({title, file})
    %{id: file.id, document: doc, description: file.description}
  end
end
