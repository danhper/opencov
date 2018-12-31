defmodule Opencov.Settings do
  use Opencov.Web, :model

  schema "settings" do
    field :signup_enabled, :boolean, default: false
    field :restricted_signup_domains, :string, default: ""
    field :default_project_visibility, :string
    field :url_mapping, :string, default: ""

    timestamps()
  end

  def get_mapping(%__MODULE__{url_mapping: mapping}) do
    mapping
    |> String.split("\n")
    |> Enum.map(&parse_mapping_line/1)
    |> Enum.reject(&is_nil/1)
  end

  defp parse_mapping_line(line) do
    case String.split(line, " ") do
      [left, right] -> %{regexp: make_mapping_regexp(left), commit_url: right}
      _ -> nil
    end
  end
  defp make_mapping_regexp(template) do
    Regex.replace(~r/\$([a-zA-Z0-9]+)/, template, "(?<\\1>[^\/]+)")
    |> Regex.compile!()
  end
end
