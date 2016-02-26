defmodule Opencov.ManagerCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Opencov.Repo
      import Opencov.Factory
      import Opencov.ManagerCase
    end
  end

  setup _tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Opencov.Repo)
  end
end
