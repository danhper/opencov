defmodule Opencov.Settings do
  use Opencov.Web, :model

  schema "settings" do
    field :signup_enabled, :boolean, default: false
    field :restricted_signup_domains, :string, default: ""
    field :default_project_visibility, :string

    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w(restricted_signup_domains signup_enabled default_project_visibility)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:default_project_visibility, Opencov.Project.visibility_choices)
    |> normalize_domains
  end

  defp normalize_domains(changeset) do
    if domains = get_change(changeset, :restricted_signup_domains) do
      put_change(changeset, :restricted_signup_domains, String.strip(domains))
    else
      changeset
    end
  end

  def get! do
    # TODO: cache the value
    Opencov.Repo.one!(Opencov.Settings)
  end

  def restricted_signup_domains do
    domains = get!.restricted_signup_domains
    |> String.split
    |> Enum.filter(&(String.contains?(&1, ".")))
    if Enum.count(domains) > 0, do: domains, else: nil
  end
end
