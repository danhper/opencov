defmodule Opencov.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_digest, :string
      add :admin, :boolean, default: false

      add :password_initialized, :boolean, default: false

      add :github_access_token, :string

      add :confirmation_token, :string
      add :confirmed_at, :utc_datetime
      add :unconfirmed_email, :string

      add :password_reset_token, :string
      add :password_reset_sent_at, :utc_datetime

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:unconfirmed_email])
    create unique_index(:users, [:confirmation_token])
    create unique_index(:users, [:password_reset_token])
  end
end
