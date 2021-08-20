defmodule Librecov.Services.Github.Checks do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Checks
  alias Librecov.Build
  import Librecov.Helpers.Coverage

  def add_pr_comment(token, owner, repo) do
    token
    |> Connection.new()
    |> Checks.checks_create(owner, repo,
      body: %{
        name: "LibreCov/commit",
        head_sha: commit,
        output: %{
          title: "Waiting for tests to finish.",
          summary: "Waiting for tests to finish."
        }
      }
    )
  end

  defp diff_conclusion(diff) when diff == 0, do: "neutral"
  defp diff_conclusion(diff) when diff < 0, do: "failure"
  defp diff_conclusion(diff) when diff > 0, do: "success"
end
