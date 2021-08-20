defmodule Librecov.JobTest do
  use Librecov.ModelCase

  alias Librecov.Job

  test "compute_coverage" do
    job = insert(:job)
    insert(:file, job: job, coverage_lines: [0, 1, nil, 0, 2, 1])
    insert(:file, job: job, coverage_lines: [0, 0, nil, 0])
    coverage = job |> Librecov.Repo.preload(:files) |> Job.compute_coverage()
    # (3 / 8 * 100)
    assert coverage == 37.5
  end
end
