defmodule Librecov.Helpers.Number do
  defguard is_greater_than(a, b)
           when trunc(a * 1000) > trunc(b * 1000)

  defguard is_less_than(a, b)
           when trunc(a * 1000) < trunc(b * 1000)

  defguard is_equal(a, b) when trunc(a * 1000) == trunc(b * 1000)

  defguard is_different(a, b)
           when trunc(a * 1000) != trunc(b * 1000)

  defguard is_zero(a) when is_equal(a, 0)
end
