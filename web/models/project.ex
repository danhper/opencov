defmodule Opencov.Project do
  use Opencov.Web, :model

  schema "projects" do
    field :name, :string
    field :token, :string
    field :current_coverage, :float
    field :base_url, :string

    has_many :builds, Opencov.Build

    timestamps
  end

  @required_fields ~w(name base_url)
  @optional_fields ~w(token current_coverage)

  before_insert :generate_token

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def generate_token(changeset) do
    change(changeset, token: unique_token)
  end

  defp unique_token do
    token = SecureRandom.urlsafe_base64(30)
    if find_by_token(token), do: unique_token, else: token
  end

  def find_by_token(token) do
    Opencov.Repo.one(
      from p in Opencov.Project,
      where: p.token == ^token,
      select: p
    )
  end
end
