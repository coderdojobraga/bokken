defmodule Bokken.FileControllerTest do
  use Bokken.DataCase
  alias Bokken.Accounts
  alias Bokken.Documents.File

  def valid_attr_mentor do
    %{
      mobile: "+351915096743",
      first_name: "Jéssica",
      last_name: "Macedo Fernandes"
    }
  end

  def valid_user_mentor do
    %{
      email: "jessica_fernandes@gmail.com",
      password: "mentor123",
      role: "mentor"
    }
  end

  def attrs_mentors do
    valid_attrs = valid_attr_mentor()
    user = valid_user_mentor()
    new_user = Accounts.create_user(user)
    user_id = elem(new_user, 1).id
    Map.put(valid_attrs, :user_id, user_id)
  end

  def mentor_fixture(atributes \\ %{}) do
    valid_attrs = attrs_mentors()

    {:ok, mentor} =
      atributes
      |> Enum.into(valid_attrs)
      |> Accounts.create_mentor()

    mentor
  end

  test "validate/1 returns true with small file" do
    user = mentor_fixture()
    title = "My title"

    document = %Plug.Upload{
      content_type: "image/png",
      filename: "avatar.png",
      path: "priv/faker/images/avatar.png"
    }

    assert {:ok, %File{}} =
             Bokken.Documents.create_file(%{
               title: title,
               description: title,
               document: document,
               user_id: user.user_id
             })
  end

  test "validate/1 returns false with large file" do
    user = mentor_fixture()
    title = "My title"

    document = %Plug.Upload{
      content_type: "image/jpg",
      filename: "large_image.jpg",
      path: "priv/faker/images/large_image.jpg"
    }

    assert {:error, "You exceeded the maximum storage quota. Try to delete one or more files"} =
             Bokken.Documents.create_file(%{
               title: title,
               description: title,
               document: document,
               user_id: user.user_id
             })
  end
end
