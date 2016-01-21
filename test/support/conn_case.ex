defmodule Opencov.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Opencov.Repo
      import Ecto.Query, only: [from: 2]
      import Opencov.Factory

      import Opencov.Router.Helpers

      # The default endpoint for testing
      @endpoint Opencov.Endpoint

      def with_login(conn) do
        password = "foobar123"
        user = build(:user)
          |> Opencov.Factory.confirmed_user
          |> Opencov.Factory.with_secure_password(password)
          |> Opencov.Repo.insert!
        post conn, auth_path(conn, :login, %{"login" => %{"email" => user.email, "password" => password}})
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Opencov.Repo, [])
    end

    :ok
  end
end
