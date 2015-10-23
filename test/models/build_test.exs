defmodule Opencov.BuildTest do
  use Opencov.ModelCase

  alias Opencov.Build
  alias Opencov.Project
  alias Ecto.Changeset

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov"}

  @valid_attrs %{coverage: 120.5, number: 42, project_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Build.changeset(%Build{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Build.changeset(%Build{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "for_project when no build exist" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    build = Build.for_project(project)
    assert build.id == nil
  end

  test "for_project when build exists" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    base_build = Build.changeset(%Build{}, @valid_attrs)
    changeset = Changeset.change(base_build, project_id: project.id, completed: false)
    existing_build = Opencov.Repo.insert! changeset
    build = Build.for_project(project)
    assert build.id == existing_build.id
  end
end
