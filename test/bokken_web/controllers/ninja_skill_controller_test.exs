defmodule BokkenWeb.NinjaSkillControllerTest do
  @moduledoc false
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias Bokken.Curriculum.NinjaSkill
  alias BokkenWeb.Authorization

  import Bokken.Factory

  @password "password1234!"

  def admin_attrs do
    user = params_for(:user, role: "organizer", password: @password)
    {:ok, new_user} = Accounts.create_user(user)

    valid_admin = params_for(:organizer)
    admin =
      valid_admin
      |> Map.put(:user_id, new_user.id)
      |> Map.put(:user, new_user)

    {:ok, new_admin} = Accounts.create_organizer(admin)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
    |> Map.put(:organizer, new_admin)
  end

  def ninja_attrs do
    user = params_for(:user, role: "ninja", password: @password)
    {:ok, new_user} = Accounts.create_user(user)

    guardian = guardian_attrs()

    ninja =
      params_for(:ninja)
      |> Map.put(:user_id, new_user.id)
      |> Map.put(:guardian_id, guardian.id)

    {:ok, new_ninja} = Accounts.create_ninja(ninja)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
    |> Map.put(:ninja, new_ninja)
  end

  def guardian_attrs do
    user = params_for(:user, role: "guardian", password: @password)
    {:ok, new_user} = Accounts.create_user(user)

    guardian =
      # valid_guardian()
      params_for(:guardian)
      |> Map.put(:user_id, new_user.id)
      |> Map.put(:user, new_user)

    {:ok, new_guardian} = Accounts.create_guardian(guardian)

    new_guardian
  end

  def ninja_guardian_attrs do
    ninja_user = params_for(:user, role: "ninja", password: @password)
    {:ok, new_ninja_user} = Accounts.create_user(ninja_user)

    guardian_user = params_for(:user, role: "guardian", password: @password)
    {:ok, new_guardian_user} = Accounts.create_user(guardian_user)

    guardian =
      params_for(:guardian)
      |> Map.put(:user_id, new_guardian_user.id)

    {:ok, new_guardian} = Accounts.create_guardian(guardian)

    ninja =
      params_for(:ninja)
      |> Map.put(:user_id, new_ninja_user.id)
      |> Map.put(:guardian_id, new_guardian.id)

    {:ok, new_ninja} = Accounts.create_ninja(ninja)

    guardian
    |> Map.put(:user_id, new_guardian_user.id)
    |> Map.put(:email, new_guardian_user.email)
    |> Map.put(:password, new_guardian_user.password)
    |> Map.put(:ninja, new_ninja)
  end

  # Create a skill
  setup %{conn: conn} do
    skill = insert(:skill)
    {:ok, conn: conn, skill: skill}
  end

  describe "logged in as organizer" do
    setup [:login_as_admin]

    test "create a ninja skill fails", %{
      conn: conn,
      skill: skill
    } do
      assert_error_sent 400, fn ->
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja), %{
          "skill" => skill.id
        })
      end
    end

    test "delete a ninja skill fails but index works", %{
      conn: conn,
      skill: skill
    } do
      ninja_id = conn.assigns.ninja

      {:ok, %NinjaSkill{} = ninja_skill} =
        Curriculum.create_ninja_skill(%{"skill_id" => skill.id, "ninja_id" => ninja_id})

      assert_error_sent 404, fn ->
        delete(conn, Routes.ninja_skill_path(conn, :delete, ninja_id, ninja_skill.id))
      end

      conn = get(conn, Routes.ninja_skill_path(conn, :index, ninja_id), %{"skill_id" => skill.id})

      assert [
               %{
                 "id" => _id,
                 "name" => _name,
                 "description" => _description
               }
             ] = json_response(conn, 200)["data"]
    end

    defp login_as_admin(%{conn: conn}) do
      admin_attrs = admin_attrs()
      ninja_attrs = ninja_attrs()

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
        |> assign(:ninja, ninja_attrs[:ninja].id)

      {:ok, conn: conn, id: admin_user.organizer.id}
    end
  end

  describe "logged in as ninja" do
    setup [:login_as_ninja]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja), %{
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
          Routes.ninja_skill_path(conn, :index, conn.assigns.current_user.ninja.id),
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
      skill: skill
    } do
      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja), %{
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
          Routes.ninja_skill_path(conn, :delete, conn.assigns.current_user.ninja.id, skill_id)
        )

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, conn.assigns.current_user.ninja.id)
        )

      assert [] = json_response(conn, 200)["data"]
    end

    defp login_as_ninja(%{conn: conn}) do
      ninja_attrs = ninja_attrs()
      {:ok, ninja_user} = Accounts.authenticate_user(ninja_attrs.email, ninja_attrs.password)

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(ninja_user, %{
          role: ninja_user.role,
          active: ninja_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{ninja_attrs[:user_id]}")
        |> assign(:ninja, ninja_attrs[:ninja].id)

      {:ok, conn: conn}
    end
  end

  describe "logged in as ninja's guardian" do
    setup [:login_as_ninja_guardian]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja_id = conn.assigns.ninja_id

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja_id), %{
          "skill" => skill.id,
          "ninja_id" => ninja_id
        })

      assert %{
               "id" => _id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]
    end

    test "delete a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja_id = conn.assigns.ninja_id

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja_id), %{
          "skill" => skill.id,
          "ninja_id" => ninja_id
        })

      assert %{
               "id" => skill_id,
               "name" => _name,
               "description" => _description
             } = json_response(conn, 201)["data"]

      conn =
        delete(
          conn,
          Routes.ninja_skill_path(conn, :delete, ninja_id, skill_id)
        )

      conn =
        get(
          conn,
          Routes.ninja_skill_path(conn, :index, ninja_id)
        )

      assert [] = json_response(conn, 200)["data"]
    end

    defp login_as_ninja_guardian(%{conn: conn}) do
      guardian_attrs = ninja_guardian_attrs()

      {:ok, guardian_user} =
        Accounts.authenticate_user(guardian_attrs.email, guardian_attrs.password)

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(guardian_user, %{
          role: guardian_user.role,
          active: guardian_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{guardian_attrs[:user_id]}")
        |> assign(:ninja_id, guardian_attrs[:ninja].id)

      {:ok, conn: conn}
    end
  end

  describe "logged in as another guardian" do
    setup [:login_as_another_guardian]

    test "create a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja_id = conn.assigns.ninja_id

      conn =
        post(conn, Routes.ninja_skill_path(conn, :create, conn.assigns.ninja_id), %{
          "skill" => skill.id,
          "ninja_id" => ninja_id
        })

      assert conn.status == 401
    end

    test "delete a ninja skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      ninja_id = conn.assigns.ninja_id

      conn =
        delete(
          conn,
          Routes.ninja_skill_path(conn, :delete, ninja_id, skill.id)
        )

      assert conn.status == 401
    end

    defp login_as_another_guardian(%{conn: conn}) do
      ninja_attrs = ninja_attrs()

      guardian_user = %{
        email: "guardian2@mail.com",
        password: "password1234",
        role: "guardian",
        active: true
      }

      {:ok, new_user} = Accounts.create_user(guardian_user)

      guardian =
        params_for(:guardian)
        |> Map.put(:user_id, new_user.id)

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
        |> put_req_header("user_id", "#{guardian[:user_id]}")
        |> assign(:ninja_id, ninja_attrs[:ninja].id)

      {:ok, conn: conn}
    end
  end
end
