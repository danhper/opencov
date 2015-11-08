defmodule Opencov.BadgeCreatorTest do
  use ExUnit.Case

  alias Opencov.BadgeCreator

  test "make_badge creates a new badge" do
    {:ok, format, output} = BadgeCreator.make_badge(50, format: :svg)
    assert format == :svg
    assert String.contains?(output, "50")
  end
end
