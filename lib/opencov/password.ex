defmodule Opencov.Password do
  @moduledoc "Password validation and bcrypt authentication, preserving existing password digests."
  import Ecto.Changeset

  defmacro __using__(_opts) do
    quote do
      import Opencov.Password
      defdelegate authenticate(user, password), to: Opencov.Password
    end
  end

  defmacro has_secure_password do
    quote do
      field(:password, :string, virtual: true)
      field(:password_confirmation, :string, virtual: true)
      field(:password_digest, :string)
    end
  end

  def with_secure_password(changeset) do
    password = get_change(changeset, :password)

    if is_binary(password) and password != "" do
      changeset =
        changeset |> validate_length(:password, min: 6) |> validate_confirmation(:password)

      if changeset.valid?,
        do: put_change(changeset, :password_digest, Bcrypt.hash_pwd_salt(password)),
        else: changeset
    else
      if changeset.data.id, do: changeset, else: add_error(changeset, :password, "can't be blank")
    end
  end

  def authenticate(nil, _password), do: Bcrypt.no_user_verify()
  def authenticate(%{password_digest: nil}, _password), do: Bcrypt.no_user_verify()

  def authenticate(user, password),
    do: Bcrypt.verify_pass(password || "", user.password_digest) && user
end
