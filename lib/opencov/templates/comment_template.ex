defmodule Librecov.Templates.CommentTemplate do
  alias Librecov.Build
  alias Librecov.Project
  alias Librecov.Endpoint
  alias Librecov.JobManager
  alias Librecov.File
  import Librecov.Router.Helpers
  import Librecov.Helpers.Coverage
  alias Librecov.Repo
  alias Librecov.Queries.BuildQueries

  def coverage_message(
        %Build{
          id: build_id,
          coverage: coverage,
          previous_coverage: previous_coverage,
          commit_sha: commit,
          branch: branch,
          project: %Project{
            id: project_id,
            current_coverage: project_coverage
          }
        } = build,
        %{
          head: %{user: %{login: username}},
          base: %{ref: base_branch, sha: base_commit}
        }
      ) do
    build = Librecov.Repo.preload(build, :jobs)

    base_build =
      project_id |> BuildQueries.latest_for_project_branch(base_branch) |> Repo.one() ||
        project_id |> BuildQueries.latest_for_project_commit(base_commit) |> Repo.one()

    real_previous_coverage =
      Map.get(base_build || %{}, :coverage) || previous_coverage || project_coverage || 0.0

    cov_dif = coverage_diff(coverage, real_previous_coverage)

    report_url = build_url(Endpoint, :show, build_id)

    header = """
    # [Librecov](#{report_url}) Report
    Hey @#{username}
    #{merge_message(cov_dif, branch, commit, report_url)}
    #{diff_message(cov_dif, coverage)}
    """

    if is_nil(base_build) do
      header
    else
      base_files =
        base_build
        |> Repo.preload([:jobs])
        |> Map.get(:jobs)
        |> JobManager.preload_files()
        |> Map.get(:files)

      files =
        build.jobs
        |> JobManager.preload_files()
        |> Map.get(:files)

      both_files =
        files
        |> Enum.map(fn f -> {f, base_files |> Enum.find(&(&1.name == f.name))} end)
        |> Enum.filter(fn {f1, f2} -> is_nil(f2) || f1.coverage != f2.coverage end)

      """
      #{header}
      #{impacted_files_message(report_url, both_files)}
      ------

      [Continue to review full report at Librecov](#{report_url}).
      > **Legend**
      > `Δ = absolute <relative> (impact)`, `ø = not affected`, `? = missing data`
      > Powered by [Librecov](#{project_url(Endpoint, :index)}).
      """
    end
  end

  defp merge_message(_, nil, _, _), do: ""
  defp merge_message(_, _, nil, _), do: ""

  defp merge_message(0.0, branch, commit, report_url),
    do:
      "> Merging [#{branch |> format_branch()}](#{report_url}) (#{commit |> format_commit()}) will **not change** coverage."

  defp merge_message(cov_dif, branch, commit, report_url),
    do:
      "> Merging [#{branch |> format_branch()}](#{report_url}) (#{commit |> format_commit()}) will **#{cov_dif |> diff_verb()}** coverage by `#{cov_dif |> format_coverage()}`."

  defp diff_message(0.0, _), do: "> The diff coverage is `n/a`."
  defp diff_message(_, coverage), do: "> The diff coverage is `#{coverage |> format_coverage()}`."

  defp impacted_files_message(_, []), do: ""

  defp impacted_files_message(report_url, files) do
    """

    | [Impacted Files](#{report_url}) | Coverage Δ | |
    |---|---|---|
    #{files |> Enum.map(&files_line/1) |> Enum.join("\n")}

    """
  end

  defp files_line({%File{} = file, %File{coverage: previous_coverage}}),
    do: file_line(file, previous_coverage)

  defp files_line({%File{} = file, nil}),
    do: file_line(file, 0.0)

  defp file_line(
         %File{
           id: file_id,
           name: filename,
           coverage: coverage
         },
         previous_coverage
       ) do
    cov_diff = coverage_diff(coverage, previous_coverage)

    "| [#{filename}](#{file_url(Endpoint, :show, file_id)}) | `#{coverage |> format_coverage()} <#{cov_diff |> format_coverage()}> (#{cov_diff |> file_icon()})` | #{cov_diff |> diff_emoji()} |"
  end

  defp diff_emoji(diff) when diff == 0, do: ""
  defp diff_emoji(diff) when diff < 0, do: "⬇️"
  defp diff_emoji(diff) when diff > 0, do: "⬆️"

  defp file_icon(diff) when diff >= 0.0 and diff <= 0.01, do: "ø"
  defp file_icon(_diff), do: "Δ"

  defp format_commit(commit), do: String.slice(commit, 0, 7)

  defp format_branch(""), do: "this"
  defp format_branch(nil), do: "this"
  defp format_branch("refs/heads/" <> branch), do: branch
  defp format_branch(branch), do: branch

  defp diff_verb(diff) when diff == 0, do: "mantain"
  defp diff_verb(diff) when diff < 0, do: "decrease"
  defp diff_verb(diff) when diff > 0, do: "increase"
end
