defmodule Opencov.Job do
  use Opencov.Web, :model

  schema "jobs" do
    field :commit_sha, :string
    field :author_name, :string
    field :author_email, :string
    field :commit_message, :string
    field :branch, :string
    field :coverage, :integer
    field :old_coverage, :integer
    field :run_at, Ecto.DateTime
    field :files_count, :integer
    field :number, :integer

    has_one :build, Opencov.Build
    has_many :files, Opencov.File

    timestamps
  end

  @required_fields ~w(build_id coverage number)
  @optional_fields ~w(run_at commit_sha author_name author_email commit_message branch)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
