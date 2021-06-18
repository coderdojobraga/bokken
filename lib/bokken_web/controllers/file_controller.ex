defmodule BokkenWeb.FileController do
  use BokkenWeb, :controller

  alias Bokken.Documents
  alias Bokken.Documents.File

  action_fallback BokkenWeb.FallbackController

  def humans_txt(conn, _params) do
    if Browser.known?(conn) do
      send_file(conn, 200, "priv/static/humans.html")
    else
      send_file(conn, 200, "priv/static/humans.txt")
    end
  end

  def images(conn, %{"type" => type, "id" => id, "file" => image}) do
    send_file(conn, 200, "uploads/#{type}/#{id}/#{image}")
  end

  def files(conn, %{"type" => type, "id" => id, "version" => version, "file" => file}) do
    send_file(conn, 200, "uploads/#{type}/#{version}/#{id}/#{file}")
  end

  def index(conn, params) do
    files = Documents.list_files(params)
    render(conn, "index.json", files: files)
  end

  def create(conn, %{"file" => file_params}) do
    with {:ok, %File{} = file} <- Documents.create_file(file_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.file_path(conn, :show, file))
      |> render("show.json", file: file)
    end
  end

  def show(conn, %{"id" => id}) do
    file = Documents.get_file!(id)
    render(conn, "show.json", file: file)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Documents.get_file!(id)

    with {:ok, %File{} = file} <- Documents.update_file(file, file_params) do
      render(conn, "show.json", file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Documents.get_file!(id)

    with {:ok, %File{}} <- Documents.delete_file(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
