defmodule Timex.Format.Time.Formatters.SimpleHumanized do
  use Timex.Format.Time.Formatter

  @minute_seconds 60
  @hour_seconds 60 * @minute_seconds
  @day_seconds 24 * @hour_seconds
  @year_seconds 365 * @day_seconds
  @month_seconds 30 * @day_seconds

  def format({mega_seconds, seconds, _}) do
    format(mega_seconds * 1_000_000 + seconds)
  end

  def format(seconds) do
    cond do
      seconds > @year_seconds ->
        n = div(seconds, @year_seconds)
        "more than #{n} #{pluralize("year", n)}"
      seconds >= @month_seconds -> approximate_time(seconds, @month_seconds, "month")
      seconds >= @day_seconds -> approximate_time(seconds, @day_seconds, "day")
      seconds >= @hour_seconds -> approximate_time(seconds, @hour_seconds, "hour")
      seconds >= @minute_seconds -> approximate_time(seconds, @minute_seconds, "minute")
      seconds -> "#{seconds} #{pluralize("second", seconds)}"
    end
  end

  defp approximate_time(seconds, unit, unit_name) do
    n = round(seconds / unit)
    "about #{n} #{pluralize("#{unit_name}", n)}"
  end

  defp pluralize(noun, count) do
    if count >= 2, do: "#{noun}s", else: noun
  end
end
