defmodule Opencov.BadgeTest do
  use ExUnit.Case

  alias Opencov.Badge

  setup do
    on_exit &Temp.cleanup/0
    {:ok, []}
  end

  test "make_badge creates a new badge" do
    path = Badge.make_badge(50)
    assert File.exists?(path)
  end
end
