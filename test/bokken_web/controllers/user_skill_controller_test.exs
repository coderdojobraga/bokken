defmodule BokkenWeb.UserSkillControllerTest do
  @moduledoc false
  use BokkenWeb.ConnCase

  alias Bokken.Accounts
  alias Bokken.Accounts.{Skill, UserSkill}
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
      mobile: "915096743",
      first_name: "Ana Maria",
      last_name: "Silva Costa"
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

    {:ok, _new_mentor} = Accounts.create_mentor(mentor)

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

    {:ok, _new_ninja} = Accounts.create_ninja(ninja)

    user
    |> Map.put(:user_id, new_user.id)
    |> Map.put(:email, new_user.email)
    |> Map.put(:password, new_user.password)
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
    {:ok, %Skill{} = skill} = Accounts.create_skill(valid_skill())
    {:ok, conn: conn, skill: skill}
  end

  describe "logged in as organizer" do
    setup [:login_as_admin]

    test "create a user skill fails", %{
      conn: conn,
      skill: skill
    } do
      assert_error_sent 400, fn ->
        post(conn, Routes.user_skill_path(conn, :create), %{"skill" => skill.id})
      end
    end

    test "delete a user skill fails but show/index works", %{
      conn: conn,
      skill: skill
    } do
      user = %{
        email: "mentor_2@gmail.com",
        password: "mentor123",
        role: "mentor"
      }

      {:ok, new_user} = Accounts.create_user(user)

      mentor = %{
        city: "Famalicão",
        mobile: "915096744",
        first_name: "Ana",
        last_name: "Costa",
        user_id: new_user.id
      }

      {:ok, new_mentor} = Accounts.create_mentor(mentor)

      {:ok, %UserSkill{} = user_skill} =
        Accounts.create_user_skill(%{"skill_id" => skill.id, "mentor_id" => new_mentor.id})

      assert_error_sent 400, fn ->
        delete(conn, Routes.user_skill_path(conn, :delete, user_skill.id))
      end

      conn = get(conn, Routes.user_skill_path(conn, :show, user_skill.id))

      assert %{
               "id" => _id,
               "mentor" => _mentor,
               "skill" => _skill
             } = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"skill_id" => skill.id})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"mentor_id" => new_mentor.id})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]
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

      {:ok, conn: conn, id: admin_user.organizer.id}
    end
  end

  describe "logged in as mentor" do
    setup [:login_as_mentor]

    test "create a user skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      conn = post(conn, Routes.user_skill_path(conn, :create), %{"skill" => skill.id})

      assert %{
               "id" => id,
               "mentor_id" => _mentor_id,
               "skill_id" => skill_id
             } = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :show, id))

      assert %{
               "id" => _id,
               "mentor" => mentor,
               "skill" => _skill
             } = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"skill_id" => skill_id})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"mentor_id" => mentor["id"]})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{})

      assert [
               %{
                 "id" => _id,
                 "mentor" => _mentor,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]
    end

    test "delete a user skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      conn = post(conn, Routes.user_skill_path(conn, :create), %{"skill" => skill.id})

      assert %{
               "id" => id,
               "mentor_id" => _mentor_id,
               "skill_id" => _skill_id
             } = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.user_skill_path(conn, :delete, id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_skill_path(conn, :show, id))
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

  describe "logged in as ninja" do
    setup [:login_as_ninja]

    test "create a user skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      conn = post(conn, Routes.user_skill_path(conn, :create), %{"skill" => skill.id})

      assert %{
               "id" => id,
               "ninja_id" => _ninja_id,
               "skill_id" => skill_id
             } = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :show, id))

      assert %{
               "id" => _id,
               "ninja" => ninja,
               "skill" => _skill
             } = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"skill_id" => skill_id})

      assert [
               %{
                 "id" => _id,
                 "ninja" => _ninja,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{"ninja_id" => ninja["id"]})

      assert [
               %{
                 "id" => _id,
                 "ninja" => _ninja,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_skill_path(conn, :index), %{})

      assert [
               %{
                 "id" => _id,
                 "ninja" => _ninja,
                 "skill" => _skill
               }
             ] = json_response(conn, 200)["data"]
    end

    test "delete a user skill succeeds", %{
      conn: conn,
      skill: skill
    } do
      conn = post(conn, Routes.user_skill_path(conn, :create), %{"skill" => skill.id})

      assert %{
               "id" => id,
               "ninja_id" => _ninja_id,
               "skill_id" => _skill_id
             } = json_response(conn, 201)["data"]

      conn = delete(conn, Routes.user_skill_path(conn, :delete, id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_skill_path(conn, :show, id))
      end
    end

    # test "show skills works", %{
    #   conn: conn
    # } do
    #   {:ok, %Skill{} = skill} = Accounts.create_skill(valid_skill())

    #   conn = get(conn, Routes.skill_path(conn, :show, skill.id))
    #   assert json_response(conn, 200)["data"]

    #   conn = get(conn, Routes.skill_path(conn, :index))
    #   assert json_response(conn, 200)["data"]
    # end

    # test "update a skill fails", %{
    #   conn: conn
    # } do
    #   {:ok, %Skill{} = skill} = Accounts.create_skill(valid_skill())

    #   skill_attrs = %{
    #     "skill" => valid_skill_update()
    #   }

    #   assert_error_sent 400, fn ->
    #     patch(conn, Routes.skill_path(conn, :update, skill.id), skill_attrs)
    #   end
    # end

    # test "delete a skill fails", %{
    #   conn: conn
    # } do
    #   {:ok, %Skill{} = skill} = Accounts.create_skill(valid_skill())

    #   assert_error_sent 400, fn ->
    #     delete(conn, Routes.skill_path(conn, :delete, skill.id))
    #   end
    # end

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

      {:ok, conn: conn}
    end
  end
end
