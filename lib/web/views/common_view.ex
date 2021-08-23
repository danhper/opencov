defmodule Librecov.CommonView do
  import Librecov.Helpers.Number
  def format_coverage(num) when is_float(num), do: "#{Float.round(num, 1)}%"
  def format_coverage(_), do: "NA"

  def coverage_color(coverage) do
    cond do
      is_nil(coverage) -> "na"
      is_zero(coverage) -> "none"
      coverage < 80 -> "low"
      coverage < 90 -> "normal"
      coverage < 100 -> "good"
      true -> "great"
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
    url = project.base_url

    cond do
      String.contains?(url, "github.com") -> "fa-github"
      String.contains?(url, "bitbucket.org") -> "fa-bitbucket"
      true -> "fa-database"
    end
  end

  def commit_link(project, sha) do
    url = project.base_url

    if String.contains?(url, "bitbucket.org") do
      "#{url}/commits/#{sha}"
    else
      "#{url}/commit/#{sha}"
    end
  end
end
