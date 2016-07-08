defmodule ExMachina.EctoWithChangesetStrategy do
  use ExMachina.Strategy, function_name: :insert

  def handle_insert(record, %{repo: repo, factory_module: module}) do
    record
    |> module.make_changeset
    |> repo.insert!
  end
end
