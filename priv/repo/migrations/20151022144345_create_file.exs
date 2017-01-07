defmodule Opencov.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    create table(:files) do
      add :job_id, :integer, null: false
      add :name, :string, null: false
      add :source, :text, null: false
      add :coverage_lines, :text, null: false
      add :coverage, :float, null: false
      add :previous_coverage, :float
      add :previous_file_id, :integer

      timestamps()
    end

    create index(:files, [:job_id])
    create unique_index(:files, [:job_id, :name])
    create index(:files, [:previous_file_id])
  end
end
