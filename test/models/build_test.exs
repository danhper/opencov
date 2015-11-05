defmodule Opencov.BuildTest do
  use Opencov.ModelCase

  alias Opencov.Build
  alias Opencov.Project
  alias Ecto.Changeset

  @project_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov"}

  @valid_attrs %{build_number: 42, project_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Build.changeset(%Build{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Build.changeset(%Build{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with real params" do
    params = Opencov.Fixtures.dummy_coverage
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    changeset = Build.changeset(Ecto.Model.build(project, :builds, build_number: 1), params)
    assert changeset.valid?

    build = Opencov.Repo.insert!(changeset)
    assert build.id
    assert build.commit_sha == params["git"]["head"]["id"]
    assert build.commit_message == params["git"]["head"]["message"]
    assert build.branch == params["git"]["branch"]
    assert build.service_name == params["service_name"]
    assert build.service_job_id == params["service_job_id"]
  end

  test "info_for when no service name and no previous build exists" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    info = Build.info_for(project, %{})
    assert info["build_number"] == 1
  end

  test "info_for when no service name and previous build exists" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    previous_build = Opencov.Repo.insert! Build.changeset(%Build{}, Dict.merge(@valid_attrs, project_id: project.id))
    info = Build.info_for(project, %{})
    assert info["build_number"] == previous_build.build_number + 1
  end

  test "previous_build when no previous build" do
    build = Opencov.Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    assert build.previous_build_id == nil
    assert build.previous_coverage == nil
  end

  test "previous_build when previous build exists" do
    changeset = Build.changeset(%Build{}, @valid_attrs)
    previous_build = Opencov.Repo.insert! Build.changeset(%Build{}, @valid_attrs)
    build = Opencov.Repo.insert! Changeset.change(changeset, build_number: 44)
    assert build.previous_build_id == previous_build.id
    assert build.previous_coverage == previous_build.coverage
  end

  test "current_for_project when no build exist" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    changeset = Changeset.change(Build.changeset(%Build{}, @valid_attrs), completed: false)
    Opencov.Repo.insert! changeset
    assert Build.current_for_project(project) == nil
  end

  test "current_for_project when build exists" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    base_build = Build.changeset(%Build{}, @valid_attrs)
    changeset = Changeset.change(base_build, project_id: project.id, completed: false)
    existing_build = Opencov.Repo.insert! changeset
    build = Build.current_for_project(project)
    assert build.id == existing_build.id
  end

  test "get_or_create! when build does not exist" do
    project = Opencov.Repo.insert! Project.changeset(%Project{}, @project_attrs)
    cov = Opencov.Fixtures.dummy_coverage
    build = Build.get_or_create!(project, cov)
    assert build.id
    assert build.commit_sha == cov["git"]["head"]["id"]
  end
end
