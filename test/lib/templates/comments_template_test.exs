defmodule Librecov.Templates.CommentTemplateTest do
  use ExUnit.Case

  import Mock

  alias Librecov.Templates.CommentTemplate

  alias Librecov.Build
  alias Librecov.Project
  alias Librecov.File

  @base_project %Project{id: 0}
  @base_build %Build{id: 0, project: @base_project}

  test "barebones template #1" do
    template =
      CommentTemplate.coverage_message(@base_build, %{
        head: %{user: %{login: "github"}},
        base: %{ref: "potato", sha: "chettos"}
      })

    assert template == "# [Librecov](http://localhost:4001/builds/0) Report\nHey @github\n\n> The diff coverage is `n/a`.\n"
  end

  test "barebones template #2" do
    template =
      CommentTemplate.coverage_message(%Build{@base_build | coverage: 50.1234}, %{
        head: %{user: %{login: "github"}},
        base: %{ref: "potato", sha: "chettos"}
      })

    assert template == "# [Librecov](http://localhost:4001/builds/0) Report\nHey @github\n\n> The diff coverage is `50.12%`.\n"
  end

  test "barebones template #3" do
    template =
      CommentTemplate.coverage_message(%Build{@base_build | coverage: 50.1234, previous_coverage: 30.2345}, %{
        head: %{user: %{login: "github"}},
        base: %{ref: "potato", sha: "chettos"}
      })

    assert template == "# [Librecov](http://localhost:4001/builds/0) Report\nHey @github\n\n> The diff coverage is `50.12%`.\n"
  end
end
