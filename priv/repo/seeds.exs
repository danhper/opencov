alias Opencov.Repo
alias Opencov.User
alias Opencov.UserManager
import Ecto.Query
require Ecto.Query

unless Repo.first(Opencov.Settings) do
  params = %{
    signup_enabled: false,
    restricted_signup_domains: "",
    default_project_visibility: "internal"
  }
  Repo.insert!(Opencov.SettingsManager.changeset(%Opencov.Settings{}, params))
end


if !Opencov.Repo.first(from u in Opencov.User, where: u.admin) do
  password = "p4ssw0rd"
  password_params = %{password: password, password_confirmation: password}
  changeset = UserManager.password_update_changeset(%User{password_initialized: false}, password_params)
  Repo.insert!(%Opencov.User{
    email: "admin@example.com",
    password_digest: changeset.changes.password_digest,
    password_initialized: true,
    confirmed_at: Timex.now,
    name: "Admin",
    admin: true
  })
end
