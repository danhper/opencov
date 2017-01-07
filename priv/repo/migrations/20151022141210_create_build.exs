defmodule Opencov.Repo.Migrations.CreateBuild do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :build_number, :integer, null: false
      add :project_id, :integer, null: false
      add :coverage, :float, null: false
      add :previous_coverage, :float
      add :previous_build_id, :integer

      add :service_name, :string
      add :service_job_id, :string
      add :service_job_pull_request, :string

      add :commit_sha, :string
      add :committer_name, :string
      add :committer_email, :string
      add :commit_message, :text
      add :branch, :string, null: false

      add :build_started_at, :utc_datetime, null: false
      add :completed, :boolean

      timestamps()
    end

    create index(:builds, [:project_id])
    create unique_index(:builds, [:project_id, :build_number])
    create index(:builds, [:previous_build_id])
  end
end
