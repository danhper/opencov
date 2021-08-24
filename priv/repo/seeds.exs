# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReferencePhx.Repo.insert!(%ReferencePhx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Librecov.Repo

Repo.insert!(%Librecov.Settings{
  id: 1,
  signup_enabled: false,
  restricted_signup_domains: "",
  default_project_visibility: "internal"
})

# Repo.insert!(%Librecov.User{
#   id: 1,
#   email: "admin@test.com",
#   password_digest: "$2b$12$hlXtMVOFfd2PxsmyDCEmwuPlHk8M1kOpOBozLSj5GO1Tn6COpHKG.",
#   password_initialized: true,
#   confirmed_at: Timex.now(),
#   name: "Admin",
#   admin: true
# })

Repo.insert!(%Librecov.Project{
  id: 1,
  name: "yknx4/librecov",
  base_url: "https://github.com/yknx4/librecov",
  current_coverage: 80.0,
  user_id: 1,
  token: "very-secure-token",
  repo_id: "github_397960449"
})
