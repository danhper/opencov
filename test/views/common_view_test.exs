defmodule Opencov.CommonViewTest do
  use Opencov.ConnCase, async: true

  import Opencov.CommonView

  test "coverage_color" do
    assert coverage_color(nil) == "na"
    assert coverage_color(0) == "none"
    assert coverage_color(1) == "low"
    assert coverage_color(50) == "low"
    assert coverage_color(80) == "normal"
    assert coverage_color(85) == "normal"
    assert coverage_color(90) == "good"
    assert coverage_color(95) == "good"
    assert coverage_color(100) == "great"
  end

  test "human_time_ago" do
    date = Timex.shift(DateTime.utc_now(), minutes: -5)
    assert human_time_ago(date) == "about 5 minutes ago"

    date = Timex.shift(DateTime.utc_now(), days: -8)
    assert human_time_ago(date) == "about 8 days ago"
  end

  test "coverage_diff" do
    assert coverage_diff(60.0, 60.0) == "Coverage has not changed."
    assert coverage_diff(64.0, 60.0) == "Coverage has decreased by 4.0%."
    assert coverage_diff(60.0, 64.0) == "Coverage has increased by 4.0%."
  end

  test "repository_class" do
    assert repository_class(build(:project, base_url: "https://github.com/tuvistavie/opencov")) == "fa-github"
    assert repository_class(build(:project, base_url: "https://bitbucket.org/tuvistavie/opencov")) == "fa-bitbucket"
    assert repository_class(build(:project, base_url: "https://gitlab.com/tuvistavie/opencov")) == "fa-gitlab"
    assert repository_class(build(:project, base_url: "https://gitlab.example.com/group/opencov")) == "fa-gitlab"
    assert repository_class(build(:project, base_url: "https://git.example.com/opencov")) == "fa-database"
  end

  test "commit_link" do
    project = build(:project, base_url: "https://github.com/tuvistavie/opencov")
    assert commit_link(project, "foobar") == "https://github.com/tuvistavie/opencov/commit/foobar"
    project = build(:project, base_url: "https://gitlab.com/tuvistavie/opencov")
    assert commit_link(project, "foobar") == "https://gitlab.com/tuvistavie/opencov/-/commit/foobar"
    project = build(:project, base_url: "https://gitlab.example.com/group/opencov/")
    assert commit_link(project, "foobar") == "https://gitlab.example.com/group/opencov/-/commit/foobar"
    project = build(:project, base_url: "https://bitbucket.org/tuvistavie/opencov")
    assert commit_link(project, "foobar") == "https://bitbucket.org/tuvistavie/opencov/commits/foobar"
  end

  test "commit_link uses the commit URL template when set" do
    project = build(:project,
      base_url: "https://bitbucket.example.com/projects/P/repos/opencov/browse",
      commit_url_template: "https://bitbucket.example.com/projects/P/repos/opencov/commits/{sha}")
    assert commit_link(project, "foobar") == "https://bitbucket.example.com/projects/P/repos/opencov/commits/foobar"
  end

  test "commit_link ignores a blank commit URL template" do
    project = build(:project, base_url: "https://github.com/tuvistavie/opencov", commit_url_template: "")
    assert commit_link(project, "foobar") == "https://github.com/tuvistavie/opencov/commit/foobar"
  end
end
