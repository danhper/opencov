defmodule Opencov.ProjectManager do
  use Opencov.Web, :manager
  alias Opencov.Project
  import Opencov.Project

  import Ecto.Query

  @required_fields ~w(name base_url)a
  @optional_fields ~w(token current_coverage)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> generate_token
  end

  def generate_token(changeset) do
    put_change(changeset, :token, unique_token())
  end

  defp unique_token() do
    token = SecureRandom.urlsafe_base64(30)
    if find_by_token(token), do: unique_token(), else: token
  end

  def find_by_token(token) do
    with_token(Project, token) |> Repo.first
  end

  def find_by_token!(token) do
    with_token(Project, token) |> Repo.first!
  end

  def update_coverage(project) do
    coverage = (Opencov.Build.last_for_project(Opencov.Build, project) |> Repo.first!).coverage
    Repo.update! change(project, current_coverage: coverage)
  end

  def preload_latest_build(projects) do
    query = from b in Opencov.Build,
            join: p in assoc(b, :project),
            where: b.completed and b.id == fragment("""
              (SELECT id
               FROM builds AS b
               WHERE b.project_id = ?
               ORDER BY b.inserted_at
               DESC LIMIT 1)
              """, p.id),
            order_by: [desc: b.inserted_at]
    Opencov.Repo.preload(projects, builds: query)
  end

  def preload_recent_builds(projects) do
    query = from b in Opencov.Build, where: b.completed, order_by: [desc: b.inserted_at], limit: 10
    Opencov.Repo.preload(projects, builds: query)
  end

  def add_job!(project, params) do
    Opencov.Repo.transaction fn ->
      build = Opencov.BuildManager.get_or_create!(project, params)
      job = Opencov.JobManager.create_from_json!(build, params)
      {build, job}
    end
  end
end
