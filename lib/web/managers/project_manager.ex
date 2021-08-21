defmodule Librecov.ProjectManager do
  use Librecov.Web, :manager
  require Logger
  alias Librecov.Project
  alias Librecov.Services.Github.Auth
  alias Librecov.Services.Github.Checks
  alias Librecov.Services.Github.Comments
  alias Librecov.Templates.CommentTemplate
  import Librecov.Project
  alias Librecov.Repo

  import Ecto.Query

  @required_fields ~w(name base_url)a
  @optional_fields ~w(token current_coverage repo_id)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> generate_token
    |> unique_constraint(:token, name: "projects_pkey")
    |> unique_constraint(:repo_id, name: "projects_repo_id_index")
  end

  def generate_token(changeset) do
    put_change(changeset, :token, unique_token())
  end

  defp unique_token() do
    token = SecureRandom.urlsafe_base64(30)
    if find_by_token(token), do: unique_token(), else: token
  end

  def find_by_token(token) do
    with_token(Project, token) |> Repo.first()
  end

  def find_by_token!(token) do
    with_token(Project, token) |> Repo.first!()
  end

  def update_coverage(project) do
    coverage =
      (Librecov.Build.last_for_project(Librecov.Build, project) |> Repo.first!()).coverage

    Repo.update!(change(project, current_coverage: coverage))
  end

  def preload_latest_build(projects) do
    query =
      from(b in Librecov.Build,
        join: p in assoc(b, :project),
        where:
          b.completed and
            b.id ==
              fragment(
                """
                (SELECT id
                 FROM builds AS b
                 WHERE b.project_id = ?
                 ORDER BY b.inserted_at
                 DESC LIMIT 1)
                """,
                p.id
              ),
        order_by: [desc: b.inserted_at]
      )

    Librecov.Repo.preload(projects, builds: query)
  end

  def preload_recent_builds(projects) do
    query =
      from(b in Librecov.Build, where: b.completed, order_by: [desc: b.inserted_at], limit: 10)

    Librecov.Repo.preload(projects, builds: query)
  end

  def add_job!(project, params) do
    Librecov.Repo.transaction(fn ->
      build = Librecov.BuildManager.get_or_create!(project, params)
      job = Librecov.JobManager.create_from_json!(build, params)

      perform_github_integrations(project, build)

      {build, job}
    end)
  end

  def perform_github_integrations(_, %Librecov.Build{id: build_id, branch: invalid})
      when invalid in [nil, ""] do
    Logger.info(
      "Skipping perform_github_integrations for Build##{build_id} because branch is empty."
    )
  end

  def perform_github_integrations(%Project{} = project, %Librecov.Build{completed: true} = build) do
    with {owner, name} <- Project.name_and_owner(project),
         {:ok, token} <- Auth.login_token(owner),
         %Librecov.Build{} = updated_build <- Repo.reload(build) do
      Logger.debug("""
      Build##{updated_build.id}
      Coverage: #{updated_build.coverage}
      Previous Coverages: #{updated_build.previous_coverage}
      """)

      Checks.finish_check(token, owner, name, updated_build, project.current_coverage)

      unless is_nil(updated_build.branch) or updated_build.branch == "" do
        CommentTemplate.coverage_message(project, updated_build)
        |> Comments.add_pr_comment(token, owner, name, updated_build.branch)
      end
    end
  end

  def perform_github_integrations(_, %Librecov.Build{id: build_id}) do
    Logger.info(
      "Waiting for Build##{build_id} to be completed before triggering github integrations."
    )

    {:ok, :skipped_github}
  end
end
