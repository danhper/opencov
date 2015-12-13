alias Opencov.Repo

unless Repo.one(Opencov.Settings), do: Repo.insert!(%Opencov.Settings{
  signup_enabled: false,
  restricted_signup_domains: nil,
  default_project_visibility: "internal"
})
