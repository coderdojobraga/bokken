defmodule BokkenWeb.NinjaSkillControllerTest do
  use BokkenWeb.ConnCase

  import Bokken.Factory

  alias Bokken.Accounts
  alias Bokken.Authorization
  alias Bokken.Curriculum
  alias Bokken.Curriculum.NinjaSkill

  # Create a skill
  setup %{conn: conn} do
    skill = insert(:skill)
    guardian = insert(:guardian)
    {:ok, conn: conn, skill: skill, guardian: guardian}
  end

  describe "logged in as organizer" do
    setup [:login_as_organizer]

    test "create a ninja skill fails", %{
      conn: conn,
      skill: skill
    } do
      ninja = insert(:ninja)

      assert_error_sent 400, fn ->
        post(conn, Routes.ninja_skill_path(conn, :create, ninja), %{
          "ninja" => %{
            "skill" => skill.id
          }
        })
      end
    end

    test "delete a ninja skill fails but index works", %{
      conn: conn,
      skill: skill
    } do
      ninja = insert(:ninja)

      {:ok, %NinjaSkill{} = ninja_skill} =
        Curriculum.create_ninja_skill(%{"skill_id" => skill.id, "ninja_id" => ninja.id})

      assert_error_sent 404, fn ->
        delete(conn, Routes.ninja_skill_path(conn, :delete, ninja.id, ninja_skill.id))
      end

      conn = get(conn, Routes.ninja_skill_path(conn, :index, ninja.id), %{"skill_id" => skill.id})

      assert [
               %{
                 "id" => _id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]
    end
  end

  describe "logged in as ninja" do
    setup [:login_as_ninja]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, user.ninja), %{
          "skill" => skill.id
        })

      assert %{
               "id" => _id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, user.ninja.id),
          %{"skill_id" => skill.id}
        )

      assert [
               %{
                 "id" => _id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, conn.assigns.current_user.ninja.id)
        )

      assert [
               %{
                 "id" => _id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, conn.assigns.current_user.ninja.id),
          %{}
        )

      assert [
               %{
                 "id" => _id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]
    end

    test "delete a ninja skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, user.ninja), %{
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
          Routes.ninja_skill_path(conn, :delete, user.ninja.id, skill_id)
        )

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, user.ninja.id)
        )

      assert [] = json_response(conn, 200)["data"]
    end
  end

  describe "logged in as ninja's guardian" do
    setup [:login_as_guardian]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      ninja_params = params_for(:ninja, guardian: user.guardian)

      {:ok, ninja} = Accounts.create_ninja(ninja_params)

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, ninja), %{
          "skill" => skill.id,
          "ninja_id" => ninja.id
        })

      assert %{
               "id" => _id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]
    end

    test "delete a ninja skill succeeds", %{
      conn: conn,
      skill: skill,
      user: user
    } do
      ninja_params = params_for(:ninja, guardian: user.guardian)

      {:ok, ninja} = Accounts.create_ninja(ninja_params)

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, ninja.id), %{
          "skill" => skill.id,
          "ninja_id" => ninja.id
        })

      assert %{
               "id" => skill_id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]

      conn =
        delete(
          conn,
          Routes.ninja_skill_path(conn, :delete, ninja.id, skill_id)
        )

      assert conn.status == 204
    end
  end

  describe "logged in as another guardian" do
    setup [:login_as_another_guardian]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja = insert(:ninja)

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, ninja.id), %{
          "skill" => skill.id,
          "ninja_id" => ninja.id
        })

      assert conn.status == 401
    end

    test "delete a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja = insert(:ninja)

      conn =
        delete(
          conn,
          Routes.ninja_skill_path(conn, :delete, ninja.id, skill.id)
        )

      assert conn.status == 401
    end

    defp login_as_another_guardian(%{conn: conn}) do
      password = "password1234"
      ninja = insert(:ninja)

      guardian_user = params_for(:user, %{role: "guardian", password: password})
      {:ok, new_user} = Accounts.create_user(guardian_user)

      guardian = params_for(:guardian, %{user: new_user})
      {:ok, _new_guardian} = Accounts.create_guardian(guardian)

      {:ok, guardian_user} =
        Accounts.authenticate_user(guardian_user.email, guardian_user.password)

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(guardian_user, %{
          role: guardian_user.role,
          active: guardian_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{guardian.user_id}")
        |> assign(:ninja_id, ninja.id)

      {:ok, conn: conn}
    end
  end
end
