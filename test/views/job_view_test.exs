defmodule Librecov.JobViewTest do
  use Librecov.ConnCase, async: true

  import Librecov.JobView

  test "job_time when run_at absent" do
    job = insert(:job)
    assert job_time(job) == job.inserted_at
  end

  test "job_time when run_at present" do
    job = insert(:job, run_at: Timex.now())
    assert job_time(job) == job.run_at
    assert job_time(job) != job.inserted_at
  end
end
