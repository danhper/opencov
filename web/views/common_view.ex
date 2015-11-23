defmodule Opencov.CommonView do
  def format_coverage(num) when is_float(num), do: "#{Float.round(num, 1)}%"
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

  def human_time_ago(time) do
    diff = Timex.Time.sub(Timex.Time.now, Timex.Date.to_timestamp(time))
    "#{Timex.Format.Time.Formatters.SimpleHumanized.format(diff)} ago"
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
    cond do
      String.contains?(url, "bitbucket.org") -> "#{url}/commits/#{sha}"
      true -> "#{url}/commit/#{sha}"
    end
  end

end
