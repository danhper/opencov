defmodule Opencov.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add(:build_id, :integer, null: false)
      add(:job_number, :integer, null: false)
      add(:coverage, :float, null: false, default: 0.0)
      add(:previous_coverage, :float)
      add(:previous_job_id, :integer)

      add(:run_at, :utc_datetime_usec)
      add(:files_count, :integer)

      timestamps()
    end

    create(index(:jobs, [:build_id]))
    create(unique_index(:jobs, [:build_id, :job_number]))
    create(index(:jobs, [:previous_job_id]))
  end
end
