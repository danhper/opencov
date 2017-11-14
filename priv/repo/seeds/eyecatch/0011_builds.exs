import Seedex

seed Opencov.Build, fn build ->
  build
  |> Map.put(:id, 1)
  |> Map.put(:project_id, 1)
  |> Map.put(:branch, "master")
  |> Map.put(:commit_sha, "fec556ae8fa374591b0bb9c91be987e96e8c94c2")
  |> Map.put(:commit_message, "Run npm install in eyecatch.rb")
  |> Map.put(:committer_name, "Daniel Perez")
  |> Map.put(:committer_email, "tuvistavie@gmail.com")
  |> Map.put(:completed, true)
  |> Map.put(:coverage, 72.83)
  |> Map.put(:build_started_at, DateTime.utc_now())
  |> Map.put(:service_name, "travis")
  |> Map.put(:build_number, 1)
end

seed Opencov.Build, fn build ->
  build
  |> Map.put(:id, 2)
  |> Map.put(:project_id, 1)
  |> Map.put(:branch, "master")
  |> Map.put(:commit_sha, "7c466d40a5f864c0cd785299b126423d37252fe8")
  |> Map.put(:commit_message, "Update dependencies")
  |> Map.put(:committer_name, "Daniel Perez")
  |> Map.put(:committer_email, "tuvistavie@gmail.com")
  |> Map.put(:completed, true)
  |> Map.put(:coverage, 74.24)
  |> Map.put(:build_started_at, DateTime.utc_now())
  |> Map.put(:service_name, "travis")
  |> Map.put(:build_number, 2)
  |> Map.put(:previous_build_id, 1)
  |> Map.put(:previous_coverage, 72.83)
end
