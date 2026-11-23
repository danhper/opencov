defmodule Opencov.Repo.Migrations.AddSourceDigestToFiles do
  use Ecto.Migration

  def up do
    alter table(:files) do
      add :source_digest, :string
    end

    execute "UPDATE files SET source_digest = md5(source)"
  end

  def down do
    alter table(:files) do
      remove :source_digest
    end
  end
end
