defmodule Opencov.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_digest, :string
      add :admin, :boolean, default: false

      timestamps
    end
    create unique_index(:users, [:email])
  end
end
