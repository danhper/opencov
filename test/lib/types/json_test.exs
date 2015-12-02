defmodule Opencov.Types.JSONText do
  use ExUnit.Case

  import Opencov.Types.JSON

  @json String.strip("""
    {"foo":"bar"}
  """)

  test "load" do
    assert load(@json) == {:ok, %{"foo" => "bar"}}
    assert {:error, _} = load("invalid_json")
  end

  test "dump" do
    assert dump(%{"foo" => "bar"}) == {:ok, @json}
    assert dump("foo") == {:ok, "foo"}
  end
end
