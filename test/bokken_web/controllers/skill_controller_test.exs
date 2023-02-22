defmodule BokkenWeb.SkillControllerTest do
  @moduledoc false
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Curriculum
  alias BokkenWeb.Authorization

  import Bokken.Factory

  @password "password1234!"

  def admin_attrs do
    user = params_for(:user, role: "organizer", password: @password)
    new_user = insert(:user, user)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  def mentor_attrs do
    user = params_for(:user, role: "mentor", password: @password)
    new_user = insert(:user, user)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
  end

  describe "logged in as organizer" do
    setup [:login_as_admin]

    test "creates a skill", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => params_for(:skill)
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
        "skill" => params_for(:skill)
      }

      conn = post(conn, Routes.skill_path(conn, :create), skill_attrs)
      assert %{"id" => skill_id} = json_response(conn, 201)["data"]

      skill_attrs = %{
        "skill" => params_for(:skill)
      }

      conn = patch(conn, Routes.skill_path(conn, :update, skill_id), skill_attrs)
      assert %{"id" => _skill_id} = json_response(conn, 200)["data"]
    end

    test "deletes a skill", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => params_for(:skill)
      }

      conn = post(conn, Routes.skill_path(conn, :create), skill_attrs)
      assert %{"id" => skill_id} = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.skill_path(conn, :delete, skill_id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.skill_path(conn, :show, skill_id))
      end
    end

    defp login_as_admin(%{conn: conn}) do
      admin_attrs = admin_attrs()

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

      {:ok, conn: conn}
    end
  end

  describe "not logged in as organizer" do
    alias Bokken.Accounts
    alias Bokken.Curriculum.Skill
    setup [:login_as_mentor]

    test "create a skill fails", %{
      conn: conn
    } do
      skill_attrs = %{
        "skill" => params_for(:skill)
      }

      assert_error_sent 500, fn ->
        post(conn, Routes.skill_path(conn, :create), skill_attrs)
      end
    end

    test "show skills works", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(params_for(:skill))

      conn = get(conn, Routes.skill_path(conn, :show, skill.id))
      assert json_response(conn, 200)["data"]

      conn = get(conn, Routes.skill_path(conn, :index))
      assert json_response(conn, 200)["data"]
    end

    test "update a skill fails", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(params_for(:skill))

      skill_attrs = %{
        "skill" => params_for(:skill)
      }

      assert_error_sent 400, fn ->
        patch(conn, Routes.skill_path(conn, :update, skill.id), skill_attrs)
      end
    end

    test "delete a skill fails", %{
      conn: conn
    } do
      {:ok, %Skill{} = skill} = Curriculum.create_skill(params_for(:skill))

      assert_error_sent 500, fn ->
        delete(conn, Routes.skill_path(conn, :delete, skill.id))
      end
    end

    defp login_as_mentor(%{conn: conn}) do
      mentor_attrs = mentor_attrs()
      {:ok, mentor_user} = Accounts.authenticate_user(mentor_attrs.email, mentor_attrs.password)

      {:ok, jwt, _claims} =
        Authorization.encode_and_sign(mentor_user, %{
          role: mentor_user.role,
          active: mentor_user.active
        })

      conn =
        conn
        |> Authorization.Plug.sign_out()
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> put_req_header("user_id", "#{mentor_attrs[:user_id]}")

      {:ok, conn: conn}
    end
  end
end
