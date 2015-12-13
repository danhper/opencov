defmodule Opencov.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :signup_enabled, :boolean, default: false
      add :restricted_signup_domains, :text
      add :default_project_visibility, :string

      timestamps
    end

  end
end
