defmodule Opencov.PasswordTest do
  use Opencov.ModelCase, async: true
  alias Opencov.{Password, User}

  test "authenticates the existing seeded bcrypt digest" do
    user = %User{password_digest: "$2b$12$hlXtMVOFfd2PxsmyDCEmwuPlHk8M1kOpOBozLSj5GO1Tn6COpHKG."}
    assert Password.authenticate(user, "p4ssw0rd") == user
    refute Password.authenticate(user, "incorrect")
    refute Password.authenticate(nil, "p4ssw0rd")
  end

  test "new passwords are validated and produce usable digests" do
    changeset =
      Opencov.UserManager.changeset(%User{}, %{email: "test@example.com", password: "password123"})

    assert changeset.valid?
    user = Ecto.Changeset.apply_changes(changeset)
    assert Password.authenticate(user, "password123") == user

    refute Opencov.UserManager.changeset(%User{}, %{email: "test@example.com", password: "short"}).valid?
  end
end
