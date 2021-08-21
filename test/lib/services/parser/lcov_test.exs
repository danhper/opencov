defmodule Librecov.Services.Parser.LcovTests do
  use ExUnit.Case
  alias Librecov.Parser.Lcov

  test "it parses an lcov" do
    {:ok, source_files} = Librecov.Fixtures.dummy_lcov() |> Lcov.parse()

    source_files
    |> Enum.each(fn source_file ->
      assert is_list(source_file.branches)
      assert is_list(source_file.coverage)
      assert is_binary(source_file.name)
      assert is_binary(source_file.source)
    end)
  end
end
