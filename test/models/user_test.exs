defmodule Opencov.UserTest do
  use Opencov.ModelCase

  alias Opencov.User

  test "changeset with valid attributes" do
    changeset = User.changeset %User{}, Map.delete(fields_for(:user), :password_confirmation)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, %{})
    refute changeset.valid?
  end

  test "password_update_changeset when user do not have a password" do
    password = "password123"
    user = create(:user, password_initialized: false)
    changeset = User.password_update_changeset(user, %{password: password, password_confirmation: password})
    assert changeset.valid?
  end

  test "password_update_changeset checks current_password when user has a password" do
    {old_password, password} = {"old_password123" ,"password123"}
    user = create(:user, password_initialized: true, password: old_password)
    changeset = User.password_update_changeset(user, %{password: password, password_confirmation: password})
    refute changeset.valid?
  end
end
