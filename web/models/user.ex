defmodule Opencov.User do
  use Opencov.Web, :model

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

    has_many(:projects, Opencov.Project)

    timestamps()
  end
end
