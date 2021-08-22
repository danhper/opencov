defmodule Librecov.Helpers.CoverageTest do
  use ExUnit.Case, async: true
  doctest Librecov.Helpers.Coverage

  alias Librecov.Web.Schemas.Job.SourceFile

  test "merges source files properly" do
    i1 = %SourceFile{name: "1", coverage: [0123], branches: [[1, 1, 1, 2]]}
    i2 = %SourceFile{name: "1", coverage: [3210], branches: [[1, 1, 1, 4]]}
    expected = %SourceFile{name: "1", coverage: [3333], branches: [[1, 1, 1, 6]]}

    assert DeepMerge.deep_merge(i1, i2) == expected
  end
end
