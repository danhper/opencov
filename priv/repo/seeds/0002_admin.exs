import Seedex

# password: p4ssw0rd
seed Opencov.User, [:email], fn user ->
  user
  |> Map.put(:email, "admin@example.com")
  |> Map.put(:password_digest, "$2b$12$hlXtMVOFfd2PxsmyDCEmwuPlHk8M1kOpOBozLSj5GO1Tn6COpHKG.")
  |> Map.put(:password_initialized, true)
  |> Map.put(:confirmed_at, Timex.now)
  |> Map.put(:name, "Admin")
  |> Map.put(:admin, true)
end
