defmodule Librecov.Helpers.Coverage do
  @doc """
  Print friendly percentage of coverage.

  ## Examples
    iex> Librecov.Helpers.Coverage.format_coverage(65.215478)
    "65.22%"
  """
  def format_coverage(coverage), do: "#{Float.round(coverage, 2)}%"

  @doc """
  Coverage differ with null handling.

  ## Examples
    iex> Librecov.Helpers.Coverage.coverage_diff(65.215478, nil)
    65.215478
    iex> Librecov.Helpers.Coverage.coverage_diff(65.0, 70.0)
    -5.0
  """
  def coverage_diff(coverage, nil), do: coverage
  def coverage_diff(coverage, previous_coverage), do: coverage - previous_coverage
end
