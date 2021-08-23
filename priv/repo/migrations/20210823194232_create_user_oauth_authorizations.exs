defmodule Librecov.Repo.Migrations.CreateUserOauthAuthorizations do
  use Ecto.Migration

  def change do
    create table(:user_oauth_authorizations) do
      add(:provider, :string, nil: false)
      add(:uid, :string, nil: false)
      add(:token, :string, nil: false)
      add(:refresh_token, :string)
      add(:expires_at, :integer)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:user_oauth_authorizations, [:user_id]))
    create(unique_index(:user_oauth_authorizations, [:provider, :uid]))
  end
end
