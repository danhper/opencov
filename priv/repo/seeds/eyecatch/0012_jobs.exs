import Seedex

seed(Opencov.Job, fn job ->
  job
  |> Map.put(:id, 1)
  |> Map.put(:build_id, 1)
  |> Map.put(:coverage, 72.8)
  |> Map.put(:files_count, 11)
  |> Map.put(:job_number, 1)
  |> Map.put(:run_at, Timex.now())
end)

seed(Opencov.Job, fn job ->
  job
  |> Map.put(:id, 2)
  |> Map.put(:build_id, 2)
  |> Map.put(:coverage, 74.24)
  |> Map.put(:files_count, 11)
  |> Map.put(:job_number, 2)
  |> Map.put(:previous_job_id, 1)
  |> Map.put(:previous_coverage, 72.8)
  |> Map.put(:run_at, Timex.now())
end)
