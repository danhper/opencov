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
end
