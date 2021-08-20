defmodule Librecov.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add(:name, :string)
      add(:token, :string)
      add(:user_id, :integer)
      add(:current_coverage, :float)
      add(:base_url, :string)
      add(:repo_id, :string)

      timestamps()
    end

    create(index(:projects, [:user_id]))
    create(unique_index(:projects, [:token]))
    create(unique_index(:projects, [:repo_id]))
  end
end
