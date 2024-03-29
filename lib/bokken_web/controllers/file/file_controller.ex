defmodule BokkenWeb.FileController do
  use BokkenWeb, :controller

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

  def index(conn, _params) when is_mentor(conn) do
    mentor_id = conn.assigns.current_user.mentor.id
    files = Documents.list_files(%{"mentor_id" => mentor_id})
    render(conn, :index, files: files)
  end

  def index(conn, _params) when is_ninja(conn) do
    ninja_id = conn.assigns.current_user.ninja.id
    files = Documents.list_files(%{"ninja_id" => ninja_id})
    render(conn, :index, files: files)
  end

  def index(conn, _params) when is_guardian(conn) do
    guardian_id = conn.assigns.current_user.guardian.id
    files = Documents.list_files(%{"guardian_id" => guardian_id})
    render(conn, :index, files: files)
  end

  def index(conn, _params) do
    files = Documents.list_files()
    render(conn, :index, files: files)
  end

  def create(conn, %{"file" => file_params}) do
    user_id = conn.assigns.current_user.id

    case Documents.create_file(Map.put(file_params, "user_id", user_id)) do
      {:ok, {:ok, file}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/files/#{file}")
        |> render(:show, file: file)

      {:ok, {:error, reason}} ->
        conn
        |> put_status(:forbidden)
        |> render("error.json", reason: reason)

      _ ->
        conn
        |> put_status(:forbidden)
        |> render("error.json",
          reason: "You exceeded the maximum storage quota. Try to delete one or more files"
        )
    end
  end

  def show(conn, %{"id" => id}) do
    file = Documents.get_file!(id)
    render(conn, :show, file: file)
  end

  def update(conn, %{"id" => id, "file" => file_params}) do
    file = Documents.get_file!(id)

    with {:ok, %File{} = file} <- Documents.update_file(file, file_params) do
      render(conn, :show, file: file)
    end
  end

  def delete(conn, %{"id" => id}) do
    file = Documents.get_file!(id)

    with {:ok, %File{}} <- Documents.delete_file(file) do
      send_resp(conn, :no_content, "")
    end
  end
end
