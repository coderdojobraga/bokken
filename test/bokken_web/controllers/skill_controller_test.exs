defmodule BokkenWeb.SkillControllerTest do
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias Bokken.Curriculum.Skill

  def valid_admin do
    %{
      email: "admin@gmail.com",
      password: "administrator123",
      role: "organizer",
      active: true
    }
  end

  def valid_mentor do
    %{
      email: "mentor@gmail.com",
      password: "mentor123",
      role: "mentor",
      active: true
    }
  end

  def valid_skill do
    %{
      name: "Kotlin #{System.unique_integer()}",
      description:
        "Kotlin is a cross-platform, statically typed, general-purpose programming language with type inference"
    }
  end

  def valid_skill_update do
    %{
      name: "Haskell"
    }
  end

  def admin_attrs do
    user = valid_admin()

    {:ok, new_user} = Accounts.create_user(user)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  def mentor_attrs do
    user = valid_mentor()

    {:ok, new_user} = Accounts.create_user(user)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  describe "logged in as organizer" do
    setup [:login_as_organizer]

    test "creates a skill", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => valid_skill()
      }

      conn = post(conn, Routes.skill_path(conn, :create), skill_attrs)

      assert %{"id" => skill_id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.skill_path(conn, :show, skill_id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.skill_path(conn, :index))
      assert json_response(conn, 200)["data"]
    end

    test "updates a skill", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => valid_skill()
      }

      conn = post(conn, Routes.skill_path(conn, :create), skill_attrs)
      assert %{"id" => skill_id} = json_response(conn, 201)["data"]

      skill_attrs = %{
        "skill" => valid_skill_update()
      }

      conn = patch(conn, Routes.skill_path(conn, :update, skill_id), skill_attrs)
      assert %{"id" => _skill_id} = json_response(conn, 200)["data"]
    end

    test "deletes a skill", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => valid_skill()
      }

      conn = post(conn, Routes.skill_path(conn, :create), skill_attrs)
      assert %{"id" => skill_id} = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.skill_path(conn, :delete, skill_id))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, Routes.skill_path(conn, :show, skill_id))
      end)
    end
  end

  describe "not logged in as organizer" do
    setup [:login_as_mentor]

    test "create a skill fails", %{
      conn: conn
    } do
      conn = post(conn, Routes.skill_path(conn, :create), skill: valid_skill())

      assert json_response(conn, 422)
    end

    test "show skills works", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(valid_skill())

      conn = get(conn, Routes.skill_path(conn, :show, skill.id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.skill_path(conn, :index))
      assert json_response(conn, 200)["data"]
    end

    test "update a skill fails because only organizers can update skills", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(valid_skill())

      assert_error_sent 400, fn ->
        put(conn, Routes.skill_path(conn, :update, skill.id), skill: valid_skill_update())
      end
    end

    test "delete a skill that does not have fails", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(valid_skill())

      conn = delete(conn, Routes.skill_path(conn, :delete, skill.id))

      assert json_response(conn, 404)
    end
  end
end
