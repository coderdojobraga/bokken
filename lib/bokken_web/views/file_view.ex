defmodule BokkenWeb.FileView do
  use BokkenWeb, :view
  alias BokkenWeb.FileView

  def render("index.json", %{files: files}) do
    %{data: render_many(files, FileView, "file.json")}
  end

  def render("show.json", %{file: file}) do
    %{data: render_one(file, FileView, "file.json")}
  end

  def render("file.json", %{file: file}) do
    %{id: file.id, document: file.document, description: file.description}
  end
end
