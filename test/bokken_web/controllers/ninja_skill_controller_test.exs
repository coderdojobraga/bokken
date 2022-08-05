defmodule BokkenWeb.NinjaSkillControllerTest do
  @moduledoc false
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias Bokken.Curriculum.{NinjaSkill, Skill}
  alias BokkenWeb.Authorization

  def valid_admin_user do
    %{
      email: "admin@gmail.com",
      password: "administrator123",
      role: "organizer"
    }
  end

  def valid_ninja_user do
    %{
      email: "ninja@gmail.com",
      password: "ninja123",
      role: "ninja"
    }
  end

  def valid_guardian_user do
    %{
      email: "guardian@gmail.com",
      password: "guardian123",
      role: "guardian"
    }
  end

  def valid_guardian do
    %{
      city: "Guimarães",
      mobile: "+351915096743",
      first_name: "Ana Maria",
      last_name: "Silva Costa"
    }
  end

  def valid_admin do
    %{
      champion: true
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

  def ninja_attrs do
    user = valid_ninja_user()
    {:ok, new_user} = Accounts.create_user(user)
    guardian = guardian_attrs()

    ninja =
      valid_ninja()
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
    user = valid_guardian_user()
    {:ok, new_user} = Accounts.create_user(user)

    guardian =
      valid_guardian()
      |> Map.put(:user_id, new_user.id)

    {:ok, new_guardian} = Accounts.create_guardian(guardian)

    new_guardian
  end

  # Create a skill
  setup %{conn: conn} do
    {:ok, %Skill{} = skill} = Curriculum.create_skill(valid_skill())
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
end
