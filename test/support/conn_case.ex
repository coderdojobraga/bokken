defmodule BokkenWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use BokkenWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """
  use ExUnit.CaseTemplate

  alias Bokken.Accounts
  alias Bokken.Authorization
  alias Bokken.Repo

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import BokkenWeb.ConnCase

      alias BokkenWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint BokkenWeb.Endpoint
    end
  end

  setup tags do
    Bokken.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in users.

      setup [:login_as_organizer]
      setup [:login_as_mentor]
      setup [:login_as_guardian]
      setup [:login_as_ninja]

  It stores an updated connection and a registered user in the
  test context.
  """
  def login_as_guardian(args), do: {:ok, register_and_log_in_user(args, :guardian)}
  def login_as_mentor(args), do: {:ok, register_and_log_in_user(args, :mentor)}
  def login_as_organizer(args), do: {:ok, register_and_log_in_user(args, :organizer)}

  def login_as_ninja(%{conn: conn, guardian: guardian}) do
    ninja_attrs = Bokken.AccountsFixtures.valid_ninja_attributes(%{guardian_id: guardian.id})

    {:ok, ninja} = Accounts.create_ninja(ninja_attrs)

    {:ok, user} =
      Accounts.create_account_for_ninja(ninja, %{"email" => Faker.Internet.free_email()})

    {:ok, [conn: log_in_user(conn, user), user: user]}
  end

  def login_as_ninja(%{conn: conn}) do
    guardian_user = Bokken.AccountsFixtures.user_fixture(%{role: :guardian})

    ninja_attrs =
      Bokken.AccountsFixtures.valid_ninja_attributes(%{guardian_id: guardian_user.guardian.id})

    {:ok, ninja} = Accounts.create_ninja(ninja_attrs)

    {:ok, user} =
      Accounts.create_account_for_ninja(ninja, %{"email" => Faker.Internet.free_email()})

    {:ok, [conn: log_in_user(conn, user), user: user]}
  end

  defp register_and_log_in_user(%{conn: conn}, role)
       when role in [:guardian, :mentor, :organizer] do
    user =
      Bokken.AccountsFixtures.user_fixture(%{role: role})
      |> Repo.preload(role)

    [conn: log_in_user(conn, user), user: user]
  end

  @doc """
  Logs the given `user` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_user(conn, user) do
    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Authorization.Plug.sign_in(user, %{role: user.role, active: user.active})
  end
end
