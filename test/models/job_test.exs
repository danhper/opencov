defmodule Opencov.JobTest do
  use Opencov.ModelCase

  alias Opencov.Job

  test "compute_coverage" do
    job = insert(:job)
    insert(:file, job: job, coverage_lines: [0, 1, nil, 0, 2, 1])
    insert(:file, job: job, coverage_lines: [0, 0, nil, 0])
    coverage = job |> Opencov.Repo.preload(:files) |> Job.compute_coverage
    assert coverage == 37.5  # (3 / 8 * 100)
  end
end
