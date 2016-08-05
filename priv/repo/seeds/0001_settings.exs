import Seedex

seed Opencov.Settings, fn settings ->
  settings
  |> Map.put(:id, 1)
  |> Map.put(:signup_enabled, false)
  |> Map.put(:restricted_signup_domains, "")
  |> Map.put(:default_project_visibility, "internal")
end
