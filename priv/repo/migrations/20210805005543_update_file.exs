defmodule Opencov.Repo.Migrations.CreateFile do
  use Ecto.Migration

  def change do
    alter table(:files) do
      modify :source, :longtext
    end
  end
end
