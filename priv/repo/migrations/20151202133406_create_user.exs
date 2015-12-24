defmodule Opencov.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_digest, :string
      add :admin, :boolean, default: false

      add :password_initialized, :boolean, default: false

      add :confirmation_token, :string
      add :confirmed_at, :datetime
      add :unconfirmed_email, :string

      timestamps
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:unconfirmed_email])
  end
end
