defmodule Opencov.BadgeTest do
  use ExUnit.Case

  alias Opencov.Badge

  test "make_badge creates a new badge" do
    {:ok, format, output} = Badge.make_badge(50, format: :svg)
    assert format == :svg
    assert String.contains?(output, "50")
  end
end
