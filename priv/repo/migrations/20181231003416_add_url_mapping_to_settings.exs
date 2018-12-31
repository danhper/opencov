defmodule Opencov.Repo.Migrations.AddUrlMappingToSettings do
  use Ecto.Migration

  def change do
    alter table(:settings) do
      add :url_mapping, :text, null: false, default: ""
    end
  end
end
