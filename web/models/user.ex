defmodule Opencov.User do
  use Opencov.Web, :model

  use SecurePassword

  schema "users" do
    field :email, :string
    field :admin, :boolean, default: false
    field :name, :string
    field :password_need_reset, :boolean, default: false
    field :confirmation_token, :string
    field :confirmed_at, Timex.Ecto.DateTime

    has_secure_password

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(admin name password)

  def changeset(model, params \\ :empty, opts \\ []) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> with_generated_password(opts)
    |> with_confirmation_token(opts)
    |> with_secure_password
  end

  defp with_generated_password(changeset, opts) do
    if opts[:generate_password] do
      change(changeset, password: SecureRandom.urlsafe_base64(12), password_need_reset: true)
    else
      changeset
    end
  end

  defp with_confirmation_token(changeset, opts) do
    if opts[:generate_token] do
      put_change(changeset, :confirmation_token, SecureRandom.urlsafe_base64(30))
    else
      changeset
    end
  end
end
