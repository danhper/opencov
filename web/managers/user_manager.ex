defmodule Opencov.UserManager do
  use Opencov.Web, :manager

  @required_fields ~w(email)a
  @optional_fields ~w(admin name password)a
  @default_secure_password_opts [
    min_length: 6,
    required: true
  ]

  def changeset(model, params \\ :invalid, opts \\ []) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> validate_email
    |> assign_unconfirmed_email
    |> unique_constraint(:unconfirmed_email)
    |> pipe_when(opts[:generate_password], generate_password)
    |> with_secure_password
  end

  def github_changeset(model, access_token) do
    Ecto.Changeset.change(model)
    |> put_change(:github_access_token, access_token)
  end

  def confirmation_changeset(model) do
    Ecto.Changeset.change(model)
    |> put_change(:email, model.unconfirmed_email)
    |> put_change(:unconfirmed_email, nil)
    |> pipe_when(is_nil(model.confirmed_at), put_change(:confirmed_at, Timex.now()))
  end

  def password_update_changeset(model, params \\ :invalid, opts \\ []) do
    model
    |> cast(params, ~w(password password_confirmation current_password)a)
    |> validate_required(~w(password password_confirmation)a)
    |> pipe_when(!opts[:skip_password_validation], validate_password_update)
    |> pipe_when(opts[:remove_reset_token], remove_reset_token)
    |> put_change(:password_initialized, true)
    |> with_secure_password
  end

  def password_reset_changeset(model) do
    change(model)
    |> generate_password_reset_token
    |> put_change(:password_reset_sent_at, Timex.now())
  end

  defp remove_reset_token(changeset) do
    change(changeset, password_reset_token: nil, password_reset_sent_at: nil)
  end

  defp validate_password_update(changeset) do
    user = changeset.data

    if !user.password_initialized or
         Opencov.User.authenticate(user, get_change(changeset, :current_password)) do
      delete_change(changeset, :current_password)
    else
      add_error(changeset, :current_password, "is invalid")
    end
  end

  defp generate_password(changeset) do
    change(changeset, password: SecureRandom.urlsafe_base64(12), password_initialized: false)
  end

  defp generate_password_reset_token(changeset) do
    put_change(changeset, :password_reset_token, SecureRandom.urlsafe_base64(30))
  end

  defp validate_email(%Ecto.Changeset{} = changeset) do
    email = get_change(changeset, :email)
    error = email && validate_email_format(email)

    if email && error do
      add_error(changeset, :email, error)
    else
      changeset
    end
  end

  defp validate_email_format(email) do
    if Regex.match?(~r/@/, email) do
      validate_domain(email)
    else
      "the email is not valid"
    end
  end

  defp assign_unconfirmed_email(changeset) do
    if new_email = get_change(changeset, :email) do
      changeset
      |> put_change(:unconfirmed_email, new_email)
      |> put_change(:confirmation_token, SecureRandom.urlsafe_base64(30))
      |> delete_change(:email)
    else
      changeset
    end
  end

  defp validate_domain(email) do
    allowed_domains = Opencov.SettingsManager.restricted_signup_domains()
    domain = email |> String.split("@") |> List.last()

    if allowed_domains && domain not in allowed_domains do
      "only the following domains are allowed: #{Enum.join(allowed_domains, ",")}"
    end
  end

  def with_secure_password(changeset, opts \\ []) do
    opts = Keyword.merge(@default_secure_password_opts, opts)

    if has_password(changeset) do
      changeset = validate_password(changeset, opts)

      if changeset.valid?,
        do: set_password_digest(changeset),
        else: changeset
    else
      if !opts[:required] || changeset_data_loaded?(changeset),
        do: changeset,
        else: add_error(changeset, :password, "can't be blank")
    end
  end

  defp has_password(%Ecto.Changeset{params: nil}), do: false

  defp has_password(changeset) do
    password = get_change(changeset, :password)
    is_binary(password) && String.length(password) > 0
  end

  defp validate_password(changeset, opts) do
    changeset
    |> check_min_length(opts[:min_length])
    |> validate_confirmation(:password)
  end

  defp set_password_digest(changeset) do
    hashed = Comeonin.Bcrypt.hashpwsalt(get_change(changeset, :password))

    changeset
    |> put_change(:password_digest, hashed)
  end

  defp changeset_data(changeset) do
    case changeset do
      # Ecto v2
      %{data: data} -> data
      # Ecto v1
      %{model: data} -> data
    end
  end

  defp check_min_length(changeset, min_length) when is_integer(min_length) do
    validate_length(changeset, :password, min: min_length)
  end

  defp check_min_length(changeset, _min_length), do: changeset

  defp changeset_data_loaded?(changeset) do
    case changeset_data(changeset) do
      # Backward compatibility
      %{id: id} ->
        id

      %{__meta__: %{state: :loaded}} ->
        true

      _ ->
        false
    end
  end
end
