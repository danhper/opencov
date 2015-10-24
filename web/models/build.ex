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
    build_number = get_change(changeset, :number)
    if build_number, do: previous_build = search_build_before(build_number)
    if previous_build do
      change(changeset, %{previous_build_id: previous_build.id, previous_coverage: previous_build.coverage})
    else
      changeset
    end
  end

  defp search_build_before(number) do
    Opencov.Repo.one(
      from b in Opencov.Build,
      select: b,
      where: b.number < ^number,
      order_by: [desc: b.number],
      limit: 1
    )
  end

  def for_project(project) do
    build = Opencov.Repo.one(
      from b in Opencov.Build,
      select: b,
      where: b.completed == false and b.project_id == ^project.id
    )
    if build do
      build
    else
      Ecto.Model.build(project, :builds)
    end
  end
end
