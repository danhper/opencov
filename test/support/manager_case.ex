defmodule Opencov.ManagerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Opencov.Repo
      import Opencov.Factory
      import Opencov.ManagerCase
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Opencov.Repo, [])
    end

    :ok
  end
end
