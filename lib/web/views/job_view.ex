defmodule Librecov.JobView do
  use Librecov.Web, :view

  import Librecov.CommonView

  def job_time(job) do
    job.run_at || job.inserted_at
  end
end
