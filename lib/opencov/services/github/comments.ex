defmodule Librecov.Services.Github.Comments do
  require Logger
  alias ExOctocat.Connection
  alias ExOctocat.Api.Issues
  alias Librecov.Services.Github.PullRequests
  alias ExOctocat.Model.PullRequestSimple

  def add_pr_comment(_, _, _, _, nil) do
    Logger.warn("Skipping because branch is nil.")
  end

  def add_pr_comment(pr_message, token, owner, repo, branch) do
    case token |> PullRequests.find_prs_for_branch(owner, repo, branch) do
      {:ok, []} ->
        Logger.info("No pull requests found for branch #{branch}")
        {:error, :pr_not_found}

      {:ok, prs} when is_list(prs) ->
        {:ok, prs |> Enum.map(&add_pr_message(token, pr_message, &1))}

      {_, e} when is_exception(e) ->
        Logger.error(e |> Exception.message())
        Sentry.capture_exception(e)
        {:error, e}

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
    Logger.info("Sending pr_message to #{owner}/#{repo}##{issue_number}.")

    {:ok, %{id: id} = comment} =
      token
      |> Connection.new()
      |> Issues.issues_create_comment(owner, repo, issue_number, body: %{body: pr_message})

    Logger.info(
      "Succesfully sent message to #{owner}/#{repo}##{issue_number}. IssueComment##{id}"
    )

    comment
  end
end
