defmodule Opencov.Repo.Migrations.AddCommitUrlTemplateToProjects do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :commit_url_template, :string
    end
  end
end
