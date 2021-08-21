defmodule Librecov.Templates.CommentTemplate do
  alias Librecov.Build
  alias Librecov.Project
  alias Librecov.Endpoint
  alias Librecov.JobManager
  alias Librecov.File
  import Librecov.Router.Helpers
  import Librecov.Helpers.Coverage

  def coverage_message(
        %Project{
          current_coverage: project_coverage
        },
        %Build{
          id: build_id,
          coverage: coverage,
          previous_coverage: previous_coverage,
          commit_sha: commit,
          branch: branch
        } = build
      ) do
    build = Librecov.Repo.preload(build, :jobs)
    real_previous_coverage = project_coverage || previous_coverage || 0.0
    cov_dif = coverage_diff(coverage, real_previous_coverage)

    report_url = build_url(Endpoint, :show, build_id)

    jobs =
      build.jobs
      |> JobManager.preload_files()

    files =
      jobs
      |> Enum.flat_map(fn job ->
        job.files
        |> Enum.filter(fn %File{coverage: coverage, previous_coverage: previous_coverage} ->
          coverage_diff(coverage, previous_coverage) != 0
        end)
      end)

    """
    # [Librecov](#{report_url}) Report
    #{merge_message(cov_dif, branch, commit, report_url)}
    #{diff_message(cov_dif, coverage)}
    #{impacted_files_message(report_url, files)}
    ------

    [Continue to review full report at Librecov](#{report_url}).
    > **Legend**
    > `Δ = absolute <relative> (impact)`, `ø = not affected`, `? = missing data`
    > Powered by [Librecov](#{project_url(Endpoint, :index)}).
    """
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
    #{files |> Enum.map(&file_line/1) |> Enum.join("\n")}

    """
  end

  defp file_line(%File{
         id: file_id,
         name: filename,
         coverage: coverage,
         previous_coverage: previous_coverage
       }) do
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
