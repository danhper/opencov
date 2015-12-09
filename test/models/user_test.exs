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
end
