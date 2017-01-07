defmodule Opencov.FileViewTest do
  use Opencov.ConnCase, async: true

  import Opencov.FileView, only: [filters: 0, short_name: 1]

  test "filters" do
    assert Enum.count(filters()) == 4
  end

  test "short_name" do
    assert short_name("foo/bar") == "foo/bar"
    assert short_name("foo/bar/baz") == "foo/bar/baz"
    f15 = String.duplicate("f", 15)
    f20 = String.duplicate("f", 20)
    assert short_name("foo/bar/baz/#{f20}") == "f/b/b/#{f20}"
    assert short_name("foo/bar/baz/#{f15}") == "f/b/baz/#{f15}"
  end
end
