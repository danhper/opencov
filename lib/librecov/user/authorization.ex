defmodule Librecov.User.Authorization do
  use Ecto.Schema
  import Ecto.Changeset
  alias Librecov.User

  schema "user_oauth_authorizations" do
    field :expires_at, :integer
    field :provider, :string
    field :refresh_token, :string
    field :token, :string
    field :uid, :string
    belongs_to :user, User

    timestamps()
  end

  @required_fields ~w(provider uid token)a
  @optional_fields ~w(refresh_token expires_at)a

  @doc """
  Creates a changeset based on the `model` and `params`.
  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:provider_uid)
  end
end
