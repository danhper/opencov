defmodule Opencov.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_digest, :string
      add :admin, :boolean, default: false

      add :password_need_reset, :boolean, default: false

      add :confirmation_token, :string
      add :confirmed_at, :datetime

      timestamps
    end
    create unique_index(:users, [:email])
  end
end
