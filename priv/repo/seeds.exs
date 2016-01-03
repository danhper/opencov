alias Opencov.Repo
alias Opencov.User
import Ecto.Query
require Ecto.Query

unless Repo.one(Opencov.Settings) do
  params = %{
    signup_enabled: false,
    restricted_signup_domains: "",
    default_project_visibility: "internal"
  }
  Repo.insert!(Opencov.Settings.changeset(%Opencov.Settings{}, params))
end


if Opencov.Repo.one!(from u in Opencov.User, select: count(u.id), where: u.admin) == 0 do
  password = "p4ssw0rd"
  password_params = %{password: password, password_confirmation: password}
  changeset = User.password_update_changeset(%User{password_initialized: false}, password_params)
  Repo.insert!(%Opencov.User{
    email: "admin@example.com",
    password_digest: changeset.changes.password_digest,
    password_initialized: true,
    confirmed_at: Timex.Date.now,
    name: "Admin",
    admin: true
  })
end
