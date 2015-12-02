defmodule Timex.Format.Time.Formatters.SimpleHumanizedTest do
  use ExUnit.Case

  import Timex.Format.Time.Formatters.SimpleHumanized

  test "format" do
    assert format(1) == "1 second"
    assert format(50) == "50 seconds"
    assert format(60) == "about 1 minute"
    assert format(89) == "about 1 minute"
    assert format(90) == "about 2 minutes"
    assert format(3600) == "about 1 hour"
    assert format(5399) == "about 1 hour"
    assert format(5400) == "about 2 hours"
    assert format(3600 * 24) == "about 1 day"
    assert format(3600 * 24 + 3600 * 12 - 1) == "about 1 day"
    assert format(3600 * 24 + 3600 * 12) == "about 2 days"
    assert format(3600 * 24 * 30) == "about 1 month"
    assert format(3600 * 24 * 30 * 2) == "about 2 months"
    assert format(3600 * 24 * 380) == "more than 1 year"
    assert format(3600 * 24 * 365 * 2) == "more than 2 years"
  end
end
