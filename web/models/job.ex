defmodule Opencov.Job do
  use Opencov.Web, :model

  schema "jobs" do
    field :build_id, :integer
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

    timestamps
  end

  @required_fields ~w(build_id commit_sha author_name author_email commit_message branch coverage old_coverage run_at files_count number)
  @optional_fields ~w()

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
