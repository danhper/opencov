defmodule Opencov.CommonView do
  def format_coverage(num) when is_float(num), do: "#{Float.round(num, 2)}%"
  def format_coverage(_), do: "NA"

  def coverage_color(coverage) do
    cond do
      is_nil(coverage) -> "na"
      coverage == 0    -> "none"
      coverage < 80    -> "low"
      coverage < 90    -> "normal"
      coverage < 100   -> "good"
      true             -> "great"
    end
  end

  def human_time_ago(datetime) do
    "about " <> Timex.from_now(datetime)
  end

  def coverage_diff(previous, current) do
    formatted_diff = abs(current - previous) |> format_coverage
    cond do
      previous == current -> "Coverage has not changed."
      previous > current -> "Coverage has decreased by #{formatted_diff}."
      previous < current -> "Coverage has increased by #{formatted_diff}."
    end
  end

  def repository_class(project) do
    case repository_host(project.base_url) do
      :github -> "fa-github"
      :gitlab -> "fa-gitlab"
      :bitbucket -> "fa-bitbucket"
      _ -> "fa-database"
    end
  end

  def commit_link(%{commit_url_template: template} = project, sha)
      when is_binary(template) and template != "" do
    if String.contains?(template, "{sha}"),
      do: String.replace(template, "{sha}", sha),
      else: default_commit_link(project.base_url, sha)
  end
  def commit_link(project, sha), do: default_commit_link(project.base_url, sha)

  defp default_commit_link(base_url, sha) do
    url = String.trim_trailing(base_url, "/")
    case repository_host(url) do
      :bitbucket -> "#{url}/commits/#{sha}"
      :gitlab -> "#{url}/-/commit/#{sha}"
      _ -> "#{url}/commit/#{sha}"
    end
  end

  # gitlab.com and self-hosted instances usually have "gitlab" in their host
  defp repository_host(url) do
    host = (URI.parse(url || "").host || url || "") |> String.downcase()
    cond do
      String.contains?(host, "github.com") -> :github
      String.contains?(host, "bitbucket.org") -> :bitbucket
      String.contains?(host, "gitlab") -> :gitlab
      true -> :other
    end
  end
end
