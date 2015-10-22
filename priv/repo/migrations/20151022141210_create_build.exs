defmodule Opencov.Repo.Migrations.CreateBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :number, :integer, null: false
      add :project_id, :integer, null: false
      add :coverage, :float, null: false
      add :old_coverage, :float
      add :service_name, :string
      add :service_pull_request, :string

      timestamps
    end

    create index(:builds, [:project_id])
    create unique_index(:builds, [:project_id, :number])
  end
end
