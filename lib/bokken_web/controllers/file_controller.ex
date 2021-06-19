defmodule BokkenWeb.FileController do
  use BokkenWeb, :controller

  alias Bokken.Accounts
  alias Bokken.Documents
  alias Bokken.Documents.File

  action_fallback BokkenWeb.FallbackController

  defguard is_image(type) when type in ~w(avatars emblems)
  defguard is_document(type) when type in ~w(snippets projects)

  def humans_txt(conn, _params) do
    if Browser.known?(conn) do
      send_file(conn, 200, "priv/static/humans.html")
    else
      send_file(conn, 200, "priv/static/humans.txt")
    end
  end

  def files(conn, %{"type" => type, "id" => id, "file" => file})
      when is_image(type) or type in ~w(projects) do
    send_file(conn, 200, "uploads/#{type}/#{id}/#{file}")
  end

  def snippets(conn, %{"user_id" => user_id, "lecture_id" => lecture_id, "file" => file}) do
    send_file(conn, 200, "uploads/snippets/#{user_id}/#{lecture_id}/#{file}")
  end

  def index(conn, %{"ninja_id" => _ninja_id} = params) do
    files = Documents.list_files(params)
    render(conn, "index.json", files: files)
  end

  def index(conn, %{"mentor_id" => _mentor_id} = params) do
    files = Documents.list_files(params)
    render(conn, "index.json", files: files)
  end

  def index(conn, _params) do
    files = Documents.list_files()
    render(conn, "index.json", files: files)
  end

  def create(conn, %{"file" => file_params}) do
    user_id = conn.assigns.current_user.id

    with {:ok, %File{} = file} <- Documents.create_file(Map.put(file_params, "user_id", user_id)) do
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
