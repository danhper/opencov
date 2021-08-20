defmodule Librecov.BuildManagerTest do
  use Librecov.ManagerCase

  alias Librecov.Build
  alias Librecov.BuildManager

  test "changeset with valid attributes" do
    changeset = BuildManager.changeset(%Build{}, Map.put(params_for(:build), :project_id, 1))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BuildManager.changeset(%Build{}, %{})
    refute changeset.valid?
  end

  test "changeset with real params" do
    params = Librecov.Fixtures.dummy_coverage()
    changeset = BuildManager.changeset(build(:build, project: nil) |> with_project, params)
    assert changeset.valid?

    build = Repo.insert!(changeset)
    assert build.id
    assert build.commit_sha == params["git"]["head"]["id"]
    assert build.commit_message == params["git"]["head"]["message"]
    assert build.branch == params["git"]["branch"]
    assert build.service_name == params["service_name"]
    assert build.service_job_id == params["service_job_id"]
  end

  test "info_for when no service name and no previous build exists" do
    project = insert(:project)
    info = BuildManager.info_for(project, %{})
    assert info["build_number"] == 1
  end

  test "info_for when no service name and previous build exists" do
    previous_build = insert(:build) |> Repo.preload(:project)
    info = BuildManager.info_for(previous_build.project, %{})
    assert info["build_number"] == previous_build.build_number + 1
  end

  test "previous_build when no previous build" do
    build = insert(:build)
    assert build.previous_build_id == nil
    assert build.previous_coverage == nil
  end

  test "previous_build when previous build exists" do
    previous_build = insert(:build) |> Repo.preload(:project)

    build =
      insert(:build,
        project: previous_build.project,
        build_number: previous_build.build_number + 1
      )

    assert build.previous_build_id == previous_build.id
    assert build.previous_coverage == previous_build.coverage
  end

  test "get_or_create! when build does not exist" do
    project = insert(:project)
    cov = Librecov.Fixtures.dummy_coverage()
    build = BuildManager.get_or_create!(project, cov)
    assert build.id
    assert build.commit_sha == cov["git"]["head"]["id"]
  end
end
