defmodule Opencov.CommonView do
  def format_coverage(num) when is_float(num), do: "#{Float.round(num, 1)}%"
  def format_coverage(_), do: "NA"
end
