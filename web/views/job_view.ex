defmodule Opencov.JobView do
  use Opencov.Web, :view

  def job_time(job) do
    job.run_at || job.inserted_at
  end
end
