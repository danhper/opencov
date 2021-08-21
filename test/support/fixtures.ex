defmodule Librecov.Fixtures do
  @sample_lcov Path.join(__DIR__, "../fixtures/lcov.info") |> File.read!()
  @coverages_path Path.join(__DIR__, "../fixtures/dummy-coverages.json")
  @coverages @coverages_path |> File.read!() |> Jason.decode!()

  def dummy_coverages do
    @coverages
  end

  def dummy_coverage(at \\ 0) do
    Enum.at(dummy_coverages(), at)
  end

  def dummy_lcov(), do: @sample_lcov

  def dummy_codecov() do
    """
    file.ex\nfile2.ex
    <<<<<< EOF
    # path=/my/coverage/lcov.info
    #{dummy_lcov()}
    <<<<<< EOF
    """
  end
end
