defmodule Opencov.SettingsManagerTest do
  use Opencov.ManagerCase

  alias Opencov.Settings
  alias Opencov.SettingsManager

  @valid_attrs %{default_project_visibility: "internal", restricted_signup_domains: "some content", signup_enabled: true}
  @invalid_attrs %{default_project_visibility: "foobar"}

  test "changeset with valid attributes" do
    changeset = SettingsManager.changeset(%Settings{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SettingsManager.changeset(%Settings{}, @invalid_attrs)
    refute changeset.valid?
  end
end
