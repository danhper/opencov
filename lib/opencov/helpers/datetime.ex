defmodule Opencov.Helpers.Datetime do
  def format(datetime, :short) do
    Timex.format!(datetime, "%Y/%m/%d %H:%M", :strftime)
  end

  def format(datetime, :dateonly) do
    Timex.format!(datetime, "%Y/%m/%d", :strftime)
  end

  def format(datetime, _), do: format(datetime)
  def format(datetime), do: Timex.format!(datetime, "{ISOz}")
end
