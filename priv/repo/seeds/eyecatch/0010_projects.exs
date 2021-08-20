import Seedex

seed(Librecov.Project, [:name], fn project ->
  project
  |> Map.put(:id, 1)
  |> Map.put(:name, "tuvistavie/librecov")
  |> Map.put(:base_url, "https://github.com/tuvistavie/librecov")
  |> Map.put(:current_coverage, 72.83)
  |> Map.put(:user_id, 1)
  |> Map.put(:token, "very-secure-token")
end)
