defmodule Opencov.Build do
  use Opencov.Web, :model

  schema "builds" do
    field :number, :integer
    field :previous_build_id, :integer
    field :coverage, :float
    field :completed, :boolean
    field :previous_coverage, :float
    field :build_started_at, Ecto.DateTime

    field :commit_sha, :string
    field :author_name, :string
    field :author_email, :string
    field :commit_message, :string
    field :branch, :string

    belongs_to :project, Opencov.Project
    has_many :jobs, Opencov.Job
    has_one :previous_build, Opencov.Build, foreign_key: :previous_build_id

    timestamps
  end

  @required_fields ~w(number project_id coverage)
  @optional_fields ~w()

  before_insert :set_build_started_at
  before_insert :set_previous_values

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defp set_build_started_at(changeset) do
    if get_change(changeset, :build_started_at) do
      changeset
    else
      put_change(changeset, :build_started_at, Ecto.DateTime.utc)
    end
  end

  defp set_previous_values(changeset) do
    {project_id, number} = {get_change(changeset, :project_id), get_change(changeset, :number)}
    previous_build = search_previous_build(project_id, number)
    if previous_build do
      change(changeset, %{previous_build_id: previous_build.id, previous_coverage: previous_build.coverage})
    else
      changeset
    end
  end

  defp search_previous_build(project_id, number) do
    Opencov.Repo.one(
      from b in Opencov.Build,
      select: b,
      where: b.project_id == ^project_id and b.number < ^number,
      order_by: [desc: b.number],
      limit: 1
    )
  end

  def current_for_project(project) do
    Opencov.Repo.one(
      from b in Opencov.Build,
      select: b,
      where: b.completed == false and b.project_id == ^project.id
    )
  end

  def new_build(project, params) do
    git_params = ~w(author_name author_email message id)
    git_info = params |> Dict.get("git", %{}) |> Dict.get("head", %{}) |> Dict.take git_params
    params_mapping = %{"id" => "commit_sha", "message" => "commit_message"}
    git_info = Enum.reduce params_mapping, git_info, fn acc, {old_key, new_key} ->
      {val, acc} = Dict.pop(acc, old_key)
      if val, do: Dict.put(acc, new_key, val), else: acc
    end
    branch = params |> Dict.get("git", %{}) |> Dict.get("branch")
    if branch, do: git_info = Dict.put(git_info, "branch", branch)
    params = params |> Dict.delete("git") |> Dict.merge(git_info)
    Ecto.Model.build(project, :builds, params)
  end
end
