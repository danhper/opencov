defmodule Opencov.ProjectTest do
  use Opencov.ModelCase

  alias Opencov.Project

  @valid_attrs %{current_coverage: "120.5", name: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
