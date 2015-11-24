defmodule Opencov.JobView do
  use Opencov.Web, :view

  import Opencov.CommonView

  def job_time(job) do
    job.run_at || job.inserted_at
  end
end
