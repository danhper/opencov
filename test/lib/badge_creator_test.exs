defmodule Librecov.BadgeCreatorTest do
  use ExUnit.Case

  import Mock

  alias Librecov.BadgeCreator

  test "make_badge creates a new badge" do
    {:ok, format, output} = BadgeCreator.make_badge(50, format: :svg)
    assert format == :svg
    assert String.contains?(output, "50")
  end

  test "make badge in other format" do
    with_mock Librecov.ImageMagick, convert: fn [input, output] -> File.copy!(input, output) end do
      {:ok, format, _} = BadgeCreator.make_badge(50, format: :png)
      assert format == :png
    end
  end
end
