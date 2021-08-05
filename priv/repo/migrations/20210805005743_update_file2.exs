defmodule Opencov.Repo.Migrations.UpdateFile do
  use Ecto.Migration

  def change do
    alter table(:files) do
      modify :source, :binary, size: 1000000
    end
  end
end
