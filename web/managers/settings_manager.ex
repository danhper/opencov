defmodule Opencov.SettingsManager do
  use Opencov.Web, :manager

  @required_fields ~w()a
  @optional_fields ~w(restricted_signup_domains signup_enabled default_project_visibility)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:default_project_visibility, Opencov.Project.visibility_choices)
    |> normalize_domains
  end

  defp normalize_domains(changeset) do
    if domains = get_change(changeset, :restricted_signup_domains) do
      put_change(changeset, :restricted_signup_domains, String.trim(domains))
    else
      changeset
    end
  end

  def get!() do
    # TODO: cache the value
    Opencov.Repo.first!(Opencov.Settings)
  end

  def restricted_signup_domains do
    domains = get!().restricted_signup_domains
    |> String.split
    |> Enum.filter(&(String.contains?(&1, ".")))
    if Enum.count(domains) > 0, do: domains, else: nil
  end
end
