defmodule Opencov.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add(:signup_enabled, :boolean, default: false, null: false)
      add(:restricted_signup_domains, :text, default: "", null: false)
      add(:default_project_visibility, :string, default: "internal", null: false)

      timestamps()
    end
  end
end
