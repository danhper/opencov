defmodule Opencov.Helpers.Datetime do
  def format(datetime, :short) do
    Timex.DateFormat.format!(datetime, "%Y/%m/%d %H:%M", :strftime)
  end
  def format(datetime, :dateonly) do
    Timex.DateFormat.format!(datetime, "%Y/%m/%d", :strftime)
  end
  def format(datetime, _), do: format(datetime)
  def format(datetime), do: Timex.DateFormat.format!(datetime, "{ISOz}")
end
