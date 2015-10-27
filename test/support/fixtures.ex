defmodule Opencov.Fixtures do
  @coverages_path Path.join(__DIR__, "../fixtures/dummy-coverages.json")
  @coverages @coverages_path |> File.read! |> Poison.decode!

  def dummy_coverages do
    @coverages
  end

  def dummy_coverage do
    Enum.at(dummy_coverages, 0)
  end
end
