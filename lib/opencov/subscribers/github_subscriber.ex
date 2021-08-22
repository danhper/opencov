defmodule Librecov.Subscriber.GithubSubscriber do
  require Logger
  alias EventBus.Model.Event
  alias Librecov.Build
  alias Librecov.Repo
  alias Librecov.Project
  alias Librecov.Services.Github.Auth
  alias Librecov.Services.Github.Checks
  alias Librecov.Services.Github.Comments
  alias Librecov.Templates.CommentTemplate

  def process({_topic, _id} = event_shadow) do
    try do
      event_shadow |> EventBus.fetch_event() |> process()
    after
      EventBus.mark_as_completed({__MODULE__, event_shadow})
    end
  end

  def process(%Event{topic: :build_finished, data: %Build{} = build}) do
    build = build |> Repo.preload([:project])

    with {owner, name} <- Project.name_and_owner(build.project),
         {:ok, token} <- Auth.login_token(owner),
         %Librecov.Build{} = updated_build <- Repo.reload(build) do
      Logger.debug("""
      Build##{updated_build.id}/#{updated_build.build_number}
      Coverage: #{updated_build.coverage}
      Previous Coverages: #{updated_build.previous_coverage}
      Performing Github Integrations
      """)

      perform_github_integrations(token, owner, name, build)
    end
  end

  def process(%Event{}) do
  end

  def perform_github_integrations(token, owner, name, %Build{branch: branch} = build)
      when branch in [nil, ""] do
    Checks.finish_check(token, owner, name, build)
  end

  def perform_github_integrations(token, owner, name, %Build{} = build) do
    Checks.finish_check(token, owner, name, build)

    CommentTemplate.coverage_message(build)
    |> Comments.add_pr_comment(token, owner, name, build)
  end
end
