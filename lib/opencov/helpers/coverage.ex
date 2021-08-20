defmodule Librecov.Helpers.Coverage do
  def format_coverage(coverage), do: "#{Float.round(coverage, 2)}%"

  def coverage_diff(coverage, nil), do: coverage
  def coverage_diff(coverage, previous_coverage), do: coverage - previous_coverage
end
