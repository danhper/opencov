defmodule Opencov.User do
  use Opencov.Web, :model

  use Opencov.Password

  schema "users" do
    field :email, :string
    field :admin, :boolean, default: false
    field :name, :string
    field :password_initialized, :boolean, default: true
    field :confirmation_token, :string
    field :confirmed_at, :utc_datetime_usec
    field :unconfirmed_email, :string

    field :password_reset_token, :string
    field :password_reset_sent_at, :utc_datetime_usec

    field :current_password, :string, virtual: true
    has_secure_password()

    has_many :projects, Opencov.Project

    timestamps()
  end
end
