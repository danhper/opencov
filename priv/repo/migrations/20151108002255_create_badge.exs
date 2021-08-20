defmodule Librecov.Repo.Migrations.CreateBadge do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add(:project_id, :integer)
      add(:image, :binary)
      add(:format, :string)
      add(:coverage, :float)

      timestamps()
    end

    create(index(:badges, [:project_id]))
    create(unique_index(:badges, [:project_id, :format]))
  end
end
