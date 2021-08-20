defmodule Librecov.ManagerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Librecov.Repo
      import Librecov.Factory
      import Librecov.ManagerCase
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Librecov.Repo)
  end
end
