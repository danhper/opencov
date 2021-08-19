import Seedex

seed(Opencov.Project, [:name], fn project ->
  project
  |> Map.put(:id, 1)
  |> Map.put(:name, "tuvistavie/opencov")
  |> Map.put(:base_url, "https://github.com/tuvistavie/opencov")
  |> Map.put(:current_coverage, 72.83)
  |> Map.put(:user_id, 1)
  |> Map.put(:token, "very-secure-token")
end)
