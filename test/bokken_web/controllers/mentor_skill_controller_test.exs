defmodule BokkenWeb.MentorSkillControllerTest do
  @moduledoc false
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias Bokken.Curriculum.{MentorSkill, Skill}
  alias BokkenWeb.Authorization

  def valid_admin_user do
    %{
      email: "admin@gmail.com",
      password: "administrator123",
      role: "organizer"
    }
  end

  def valid_mentor_user do
    %{
      email: "mentor@gmail.com",
      password: "mentor123",
      role: "mentor"
    }
  end

  def valid_admin do
    %{
      champion: true
    }
  end

  def valid_mentor do
    %{
      city: "Braga",
      mobile: "915096743",
      first_name: "Ana Maria",
      last_name: "Silva Costa"
    }
  end

  def valid_ninja do
    %{
      first_name: "Joana",
      last_name: "Costa",
      birthday: ~U[2007-03-14 00:00:00.000Z]
    }
  end

  def valid_skill do
    %{
      name: "Kotlin",
      description:
        "Kotlin is a cross-platform, statically typed, general-purpose programming language with type inference"
    }
  end

  def admin_attrs do
    user = valid_admin_user()
    {:ok, new_user} = Accounts.create_user(user)

    admin =
      valid_admin()
      |> Map.put(:user_id, new_user.id)

    {:ok, _new_admin} = Accounts.create_organizer(admin)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  def mentor_attrs do
    user = valid_mentor_user()
    {:ok, new_user} = Accounts.create_user(user)

    mentor =
      valid_mentor()
      |> Map.put(:user_id, new_user.id)

    {:ok, new_mentor} = Accounts.create_mentor(mentor)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
    |> Map.put(:mentor, new_mentor)
  end

  # Create a skill
  setup %{conn: conn} do
    {:ok, %Skill{} = skill} = Curriculum.create_skill(valid_skill())
    {:ok, conn: conn, skill: skill}
  end

  describe "logged in as organizer" do
    setup [:login_as_admin]

    test "create a mentor skill fails", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      assert_error_sent 400, fn ->
        post(conn, Routes.mentor_skill_path(conn, :create, user.mentor.id), %{
          "skill" => skill.id
        })
      end
    end

    test "delete a mentor skill fails but show/index works", %{
      conn: conn,
      skill: skill
    } do
      mentor_id = conn.assigns.mentor

      {:ok, %MentorSkill{} = mentor_skill} =
        Curriculum.create_mentor_skill(%{"skill_id" => skill.id, "mentor_id" => mentor_id})

      assert_error_sent 404, fn ->
        delete(conn, Routes.mentor_skill_path(conn, :delete, mentor_id, mentor_skill.id))
      end

      conn =
        get(conn, Routes.mentor_skill_path(conn, :index, mentor_id), %{
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

    defp login_as_admin(%{conn: conn}) do
      admin_attrs = admin_attrs()
      mentor_attrs = mentor_attrs()

      {:ok, admin_user} = Accounts.authenticate_user(admin_attrs.email, admin_attrs.password)

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(admin_user, %{
          role: admin_user.role,
          active: admin_user.active
        })

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{admin_attrs[:user_id]}")
        |> assign(:mentor, mentor_attrs[:mentor].id)

      {:ok, conn: conn, id: admin_user.organizer.id}
    end
  end

  describe "logged in as mentor" do
    setup [:register_and_log_in_mentor]

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
      skill: skill
    } do
      conn =
        post(conn, Routes.mentor_skill_path(conn, :create, conn.assigns.mentor), %{
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
