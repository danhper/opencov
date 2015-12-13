defmodule Opencov.Settings do
  use Opencov.Web, :model

  schema "settings" do
    field :signup_enabled, :boolean, default: false
    field :restricted_signup_domains, :string
    field :default_project_visibility, :string

    timestamps
  end

  @required_fields ~w(signup_enabled restricted_signup_domains default_project_visibility)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def get! do
    Opencov.Repo.one!(Opencov.Settings)
  end
end
