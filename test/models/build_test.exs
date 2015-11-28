defmodule Opencov.BuildTest do
  use Opencov.ModelCase

  alias Opencov.Build

  test "changeset with valid attributes" do
    changeset = Build.changeset(%Build{}, Dict.put(fields_for(:build), :project_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Build.changeset(%Build{}, %{})
    refute changeset.valid?
  end

  test "changeset with real params" do
    params = Opencov.Fixtures.dummy_coverage
    changeset = Build.changeset(build(:build) |> with_project, params)
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
    project = create(:project)
    info = Build.info_for(project, %{})
    assert info["build_number"] == 1
  end

  test "info_for when no service name and previous build exists" do
    previous_build = create(:build)
    info = Build.info_for(previous_build.project, %{})
    assert info["build_number"] == previous_build.build_number + 1
  end

  test "previous_build when no previous build" do
    build = create(:build)
    assert build.previous_build_id == nil
    assert build.previous_coverage == nil
  end

  test "previous_build when previous build exists" do
    previous_build = create(:build)
    build = create(:build, build_number: 44, project: previous_build.project)
    assert build.previous_build_id == previous_build.id
    assert build.previous_coverage == previous_build.coverage
  end

  test "current_for_project when no build exist" do
    create(:build, completed: false)
    assert Build.current_for_project(create(:project)) == nil
  end

  test "current_for_project when build exists" do
    existing_build = create(:build, completed: false)
    build = Build.current_for_project(existing_build.project)
    assert build.id == existing_build.id
  end

  test "get_or_create! when build does not exist" do
    project = create(:project)
    cov = Opencov.Fixtures.dummy_coverage
    build = Build.get_or_create!(project, cov)
    assert build.id
    assert build.commit_sha == cov["git"]["head"]["id"]
  end
end
