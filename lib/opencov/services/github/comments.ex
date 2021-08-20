defmodule Librecov.Services.Github.Comments do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Issues
  alias Librecov.Build
  import Librecov.Helpers.Coverage
  alias Librecov.Services.Github.PullRequests
  alias ExOctocat.Model.PullRequestSimple

  def add_pr_comment(pr_message, token, owner, repo, branch) do
    case token |> PullRequests.find_prs_for_branch(owner, repo, branch) do
      [] ->
        Logger.info("No pull requests found for branch #{branch}")

      prs when is_list(prs) ->
        prs |> Enum.each(&add_pr_message(token, pr_message, &1))

      {_, e} when is_exception(e) ->
        Logger.error(e |> Exception.message())
        Sentry.capture_exception(e)

      {_, %{message: message}} ->
        Logger.error(message)

        raise(
          "Error processing add_pr_comment(pr_message, #{token}, #{owner}, #{repo}, #{branch}): #{message}."
        )

      e ->
        IO.inspect(e)

        raise(
          "Error processing add_pr_comment(pr_message, #{token}, #{owner}, #{repo}, #{branch})."
        )
    end
  end

  def add_pr_message(token, pr_message, %PullRequestSimple{
        number: issue_number,
        base: %{repo: %{name: repo, owner: %{login: owner}}}
      }) do
    token
    |> Connection.new()
    |> Issues.issues_create_comment(owner, repo, issue_number, body: pr_message)
  end
end
