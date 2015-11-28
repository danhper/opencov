defmodule Opencov.ProjectTest do
  use Opencov.ModelCase

  alias Opencov.Project

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, fields_for(:project))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, %{})
    refute changeset.valid?
  end

  test "find_by_token with existing token" do
    project = create(:project)
    assert Project.find_by_token(project.token) == project
  end

  test "find_by_token with inexisting token" do
    assert Project.find_by_token("inexisting") == nil
  end

  test "find_by_token! with existing token" do
    project = create(:project)
    assert Project.find_by_token!(project.token) == project
  end

  test "find_by_token! with inexisting token" do
    assert_raise Ecto.NoResultsError, fn -> Project.find_by_token!("inexisting") end
  end

  test "add_job!" do
    project = create(:project)
    cov = Opencov.Fixtures.dummy_coverage
    {:ok, {build, job}} = Project.add_job!(project, cov)
    assert build.id
    assert job.id
    assert build.commit_sha == cov["git"]["head"]["id"]
    assert Enum.count(Repo.preload(job, :files).files) == Enum.count(cov["source_files"])
    assert Repo.get!(Opencov.Build, build.id).coverage == job.coverage
    assert Repo.get!(Opencov.Project, project.id).current_coverage == job.coverage
  end
end
