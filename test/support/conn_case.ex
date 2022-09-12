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

  alias BokkenWeb.Authorization

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

      setup :register_and_log_in_guardian
      setup :register_and_log_in_mentor
      setup :register_and_log_in_ninja
      setup :register_and_log_in_organizer

  It stores an updated connection and a registered user in the
  test context.
  """
  def register_and_log_in_guardian(args) do
    register_and_log_in_user(args, :guardian)
  end

  def register_and_log_in_mentor(args) do
    register_and_log_in_user(args, :mentor)
  end

  def register_and_log_in_ninja(args) do
    register_and_log_in_user(args, :ninja)
  end

  def register_and_log_in_organizer(args) do
    register_and_log_in_user(args, :organizer)
  end

  defp register_and_log_in_user(%{conn: conn}, role)
       when role in [:guardian, :mentor, :ninja, :organizer] do
    user = Bokken.AccountsFixtures.user_fixture(%{role: role})
    %{conn: log_in_user(conn, user), user: user}
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
