defmodule Librecov.UserManagerTest do
  use Librecov.ManagerCase

  alias Librecov.User
  alias Librecov.UserManager

  test "changeset with valid attributes" do
    changeset =
      UserManager.changeset(%User{}, Map.delete(params_for(:user), :password_confirmation))

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = UserManager.changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "password_update_changeset when user do not have a password" do
    password = "password123"
    user = insert(:user, password_initialized: false)

    changeset =
      UserManager.password_update_changeset(user, %{
        password: password,
        password_confirmation: password
      })

    assert changeset.valid?
  end

  test "password_update_changeset checks current_password when user has a password" do
    {old_password, password} = {"old_password123", "password123"}
    user = insert(:user, password_initialized: true, password: old_password)

    changeset =
      UserManager.password_update_changeset(user, %{
        password: password,
        password_confirmation: password
      })

    refute changeset.valid?
  end
end
