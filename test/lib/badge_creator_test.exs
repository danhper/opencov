defmodule Opencov.BadgeCreatorTest do
  use ExUnit.Case

  import Mock

  alias Opencov.BadgeCreator

  test "make_badge creates a new badge" do
    {:ok, format, output} = BadgeCreator.make_badge(50, format: :svg)
    assert format == :svg
    assert String.contains?(output, "50")
  end

  test "make badge in other format" do
    convert_mock = [cmd: fn("convert", [input, output]) -> {File.copy!(input, output), 0} end]
    with_mock System, [:passthrough], convert_mock do
      {:ok, format, _} = BadgeCreator.make_badge(50, format: :png)
      assert format == :png
    end
  end
end
