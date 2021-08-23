defmodule Librecov.ConnCase do
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
      import Plug.Conn
      import Phoenix.ConnTest

      alias Librecov.Repo
      import Ecto.Query, only: [from: 2]
      import Librecov.Factory

      import Librecov.Router.Helpers

      # The default endpoint for testing
      @endpoint Librecov.Endpoint

      def with_login(conn) do
        password = "foobar123"

        user =
          build(:user)
          |> Librecov.Factory.confirmed_user()
          |> Librecov.Factory.with_secure_password(password)
          |> Librecov.Repo.insert!()

        post(
          conn,
          session_path(conn, :create, %{
            "account" => %{"email" => user.email, "password" => password}
          })
        )
      end
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Librecov.Repo)
  end
end
