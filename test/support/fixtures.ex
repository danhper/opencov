defmodule Librecov.Fixtures do
  @coverages_path Path.join(__DIR__, "../fixtures/dummy-coverages.json")
  @coverages @coverages_path |> File.read!() |> Jason.decode!()

  def dummy_coverages do
    @coverages
  end

  def dummy_coverage(at \\ 0) do
    Enum.at(dummy_coverages(), at)
  end
end
