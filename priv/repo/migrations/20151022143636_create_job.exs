defmodule Opencov.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :build_id, :integer, null: false
      add :number, :integer, null: false
      add :coverage, :float, null: false
      add :previous_coverage, :float
      add :previous_job_id, :integer

      add :run_at, :datetime
      add :files_count, :integer

      timestamps
    end

    create index(:jobs, [:build_id])
    create unique_index(:jobs, [:build_id, :number])
    create index(:jobs, [:previous_job_id])
  end
end
