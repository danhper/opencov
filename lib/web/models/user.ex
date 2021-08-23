defmodule Librecov.User do
  use Librecov.Web, :model

  schema "users" do
    field(:email, :string)
    field(:admin, :boolean, default: false)
    field(:name, :string)
    field(:password_initialized, :boolean, default: true)
    field(:confirmation_token, :string)
    field(:confirmed_at, :utc_datetime_usec)
    field(:unconfirmed_email, :string)

    field(:github_access_token)
    field(:github_info, :map, virtual: true)

    field(:password_reset_token, :string)
    field(:password_reset_sent_at, :utc_datetime_usec)

    field(:current_password, :string, virtual: true)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:password_digest, :string)

    has_many(:projects, Librecov.Project)

    timestamps()
  end

  def changeset(struct, params) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_confirmation(:password, required: true)
    |> unique_constraint(:email, name: "users_email_index")
    |> put_encrypted_password()
  end

  defp put_encrypted_password(%{valid?: true, changes: %{password: pw}} = changeset) do
    put_change(changeset, :password_digest, Argon2.hash_pwd_salt(pw))
  end

  defp put_encrypted_password(changeset) do
    changeset
  end

  def oauth_changeset(struct, params) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
