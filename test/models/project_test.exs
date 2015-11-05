defmodule Opencov.ProjectTest do
  use Opencov.ModelCase

  alias Opencov.Project

  @valid_attrs %{name: "some content", base_url: "https://github.com/tuvistavie/opencov"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "find_by_token with existing token" do
    project = Repo.insert! Project.changeset(%Project{}, @valid_attrs)
    assert Project.find_by_token(project.token) == project
  end

  test "find_by_token with inexisting token" do
    assert Project.find_by_token("inexisting") == nil
  end

  test "add_job!" do
    project = Repo.insert! Project.changeset(%Project{}, @valid_attrs)
    cov = Opencov.Fixtures.dummy_coverage
    {build, job} = Project.add_job!(project, cov)
    assert build.id
    assert job.id
    assert build.commit_sha == cov["git"]["head"]["id"]
    assert Enum.count((job |> Repo.preload(:files)).files) == Enum.count(cov["source_files"])
  end
end
