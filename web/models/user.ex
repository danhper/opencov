defmodule Opencov.User do
  use Opencov.Web, :model

  use SecurePassword

  schema "users" do
    field :email, :string
    field :admin, :boolean, default: false
    field :name, :string
    field :password_initialized, :boolean, default: true
    field :confirmation_token, :string
    field :confirmed_at, Timex.Ecto.DateTime
    field :unconfirmed_email, :string

    field :password_reset_token, :string
    field :password_reset_sent_at, Timex.Ecto.DateTime

    field :current_password, :string, virtual: true
    has_secure_password

    has_many :projects, Opencov.Project

    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(admin name password)

  def changeset(model, params \\ :empty, opts \\ []) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_email
    |> assign_unconfirmed_email
    |> unique_constraint(:unconfirmed_email)
    |> pipe_when(opts[:generate_password], generate_password)
    |> pipe_when(opts[:generate_token], generate_confirmation_token)
    |> with_secure_password
  end

  def confirmation_changeset(model) do
    Ecto.Changeset.change(model)
    |> put_change(:email, model.unconfirmed_email)
    |> put_change(:unconfirmed_email, nil)
    |> pipe_when(is_nil(model.confirmed_at), put_change(:confirmed_at, Timex.Date.now))
  end

  def password_update_changeset(model, params \\ :empty, opts \\ []) do
    model
    |> cast(params, ~w(password password_confirmation), ~w(current_password))
    |> pipe_when(!opts[:skip_password_validation], validate_password_update)
    |> pipe_when(opts[:remove_reset_token], remove_reset_token)
    |> put_change(:password_initialized, true)
    |> with_secure_password
  end

  def password_reset_changeset(model) do
    change(model)
    |> generate_password_reset_token
    |> put_change(:password_reset_sent_at, Timex.Date.now)
  end

  defp remove_reset_token(changeset) do
    change(changeset, password_reset_token: nil, password_reset_sent_at: nil)
  end

  defp validate_password_update(changeset) do
    user = changeset.model
    if !user.password_initialized or Opencov.User.authenticate(user, get_change(changeset, :current_password)) do
      delete_change(changeset, :current_password)
    else
      add_error(changeset, :current_password, "is invalid")
    end
  end

  defp generate_password(changeset) do
    change(changeset, password: SecureRandom.urlsafe_base64(12), password_initialized: false)
  end

  defp generate_confirmation_token(changeset) do
    put_change(changeset, :confirmation_token, SecureRandom.urlsafe_base64(30))
  end

  defp generate_password_reset_token(changeset) do
    put_change(changeset, :password_reset_token, SecureRandom.urlsafe_base64(30))
  end

  defp validate_email(%Ecto.Changeset{} = changeset) do
    if (email = get_change(changeset, :email)) && (error = validate_email_format(email)) do
      add_error(changeset, :email, error)
    else
      changeset
    end
  end

  defp validate_email_format(email) do
    if not Regex.match?(~r/@/, email) do
      "the email is not valid"
    else
      validate_domain(email)
    end
  end

  defp assign_unconfirmed_email(changeset) do
    if new_email = get_change(changeset, :email) do
      changeset |> put_change(:unconfirmed_email, new_email) |> delete_change(:email)
    else
      changeset
    end
  end

  defp validate_domain(email) do
    allowed_domains = Opencov.Settings.restricted_signup_domains
    domain = email |> String.split("@") |> List.last
    if allowed_domains && not domain in allowed_domains do
      "only the following domains are allowed: #{Enum.join(allowed_domains, ",")}"
    end
  end
end
