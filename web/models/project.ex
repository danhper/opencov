defmodule Opencov.Project do
  use Opencov.Web, :model

  import Ecto.Query

  schema "projects" do
    field :name, :string
    field :token, :string
    field :current_coverage, :float
    field :base_url, :string

    has_many :builds, Opencov.Build

    timestamps
  end

  @required_fields ~w(name base_url)
  @optional_fields ~w(token current_coverage)

  before_insert :generate_token

  def preload_latest_build(projects) do
    query = from b in Opencov.Build,
            join: p in assoc(b, :project),
            where: b.completed and b.id == fragment("(SELECT id FROM builds AS b WHERE b.project_id = ? ORDER BY b.inserted_at DESC LIMIT 1)", p.id),
            order_by: [desc: b.inserted_at]
    projects |> Opencov.Repo.preload(builds: query)
  end


  def preload_recent_builds(projects) do
    query = from b in Opencov.Build, where: b.completed, order_by: [desc: b.inserted_at], limit: 10
    projects |> Opencov.Repo.preload(builds: query)
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def generate_token(changeset) do
    change(changeset, token: unique_token)
  end

  defp unique_token do
    token = SecureRandom.urlsafe_base64(30)
    if find_by_token(token), do: unique_token, else: token
  end

  def find_by_token(token) do
    Opencov.Repo.one(base_query |> with_token(token))
  end

  def find_by_token!(token) do
    Opencov.Repo.one!(base_query |> with_token(token))
  end

  def add_job!(project, params) do
    Opencov.Repo.transaction fn ->
      build = Opencov.Build.get_or_create!(project, params)
      job = Opencov.Job.create_from_json!(build, params)
      {build, job}
    end
  end

  defp base_query do
    from p in Opencov.Project, select: p
  end

  defp with_token(query, token) do
    query |> where([p], p.token == ^token)
  end

  def update_coverage(project) do
    coverage = Opencov.Build.last_for_project(project).coverage
    Opencov.Repo.update! %{project | current_coverage: coverage}
  end
end
