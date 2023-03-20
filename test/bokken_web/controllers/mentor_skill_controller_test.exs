defmodule BokkenWeb.MentorSkillControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  alias Bokken.Curriculum
  alias Bokken.Curriculum.MentorSkill

  import Bokken.Factory

  @password "password1234!"

  def admin_attrs do
    user = params_for(:user, role: "organizer", password: @password)
    new_user = insert(:user, user)

    new_admin = insert(:organizer, user_id: new_user.id, user: new_user)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, @password)
    |> Map.put(:organizer, new_admin)
  end

  def mentor_attrs do
    user = params_for(:user, role: "mentor", password: @password)
    new_user = insert(:user, user)

    new_mentor = insert(:mentor, %{user: new_user})

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, @password)
    |> Map.put(:mentor, new_mentor)
  end

  # Create a skill
  setup %{conn: conn} do
    skill = insert(:skill)
    {:ok, conn: conn, skill: skill}
  end

  describe "logged in as organizer" do
    setup [:login_as_organizer]

    test "create a mentor skill fails", %{
      conn: conn,
      skill: skill
    } do
      mentor = insert(:mentor)

      assert_error_sent 400, fn ->
        post(conn, Routes.mentor_skill_path(conn, :create, mentor), %{
          "skill" => skill.id
        })
      end
    end

    test "delete a mentor skill fails but show/index works", %{
      conn: conn,
      skill: skill
    } do
      mentor = insert(:mentor)

      {:ok, %MentorSkill{} = mentor_skill} =
        Curriculum.create_mentor_skill(%{"skill_id" => skill.id, "mentor_id" => mentor.id})

      assert_error_sent 404, fn ->
        delete(conn, Routes.mentor_skill_path(conn, :delete, mentor.id, mentor_skill.id))
      end

      conn =
        get(conn, Routes.mentor_skill_path(conn, :index, mentor.id), %{
          "skill_id" => skill.id
        })

      assert [
               %{
                 "id" => _skill_id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "logged in as mentor" do
    setup [:login_as_mentor]

    test "create a mentor skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      conn =
        post(conn, Routes.mentor_skill_path(conn, :create, user.mentor.id), %{
          "skill" => skill.id
        })

      assert %{
               "id" => skill_id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]

      conn =
        get(
          conn,
          Routes.mentor_skill_path(conn, :index, conn.assigns.current_user.mentor.id),
          %{"skill_id" => skill_id}
        )

      assert [
               %{
                 "id" => _skill_id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.mentor_skill_path(conn, :index, conn.assigns.current_user.mentor.id)
        )

      assert [
               %{
                 "id" => _skill_id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.mentor_skill_path(conn, :index, conn.assigns.current_user.mentor.id),
          %{}
        )

      assert [
               %{
                 "id" => _skill_id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]
    end

    test "delete a user skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      conn =
        post(conn, Routes.mentor_skill_path(conn, :create, user.mentor.id), %{
          "skill" => skill.id
        })

      assert %{
               "id" => skill_id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]

      conn =
        delete(
          conn,
          Routes.mentor_skill_path(conn, :delete, conn.assigns.current_user.mentor.id, skill_id)
        )

      assert response(conn, 204)

      conn =
        get(
          conn,
          Routes.mentor_skill_path(conn, :index, conn.assigns.current_user.mentor.id)
        )

      assert [] = json_response(conn, 200)["data"]
    end
  end
end
