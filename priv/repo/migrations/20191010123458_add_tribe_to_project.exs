defmodule Opencov.Repo.Migrations.AddTribeToProject do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :tribe, :string
    end

    create index(:projects, [:tribe])
  end
end
