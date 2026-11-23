defmodule Opencov.FileManager do
  use Opencov.Web, :manager
  import Opencov.File
  alias Opencov.File

  @required_fields ~w(name coverage_lines)a
  # `source` may be empty (e.g. an empty Python `__init__.py`) or missing
  # entirely when the client only sends `source_digest`, as newer coveralls
  # clients do.
  @optional_fields ~w(job_id source source_digest)a

  def changeset(model, params \\ :invalid) do
    model
    |> cast(normalize_params(params), @required_fields ++ @optional_fields, empty_values: [nil])
    |> validate_required(@required_fields)
    |> put_default_source
    |> put_source_digest
    |> generate_coverage
    |> prepare_changes(&set_previous_file/1)
  end

  defp normalize_params(%{"coverage" => coverage} = params) when is_list(coverage) do
    {lines, params} = Map.pop(params, "coverage")
    Map.put(params, "coverage_lines", lines)
  end
  defp normalize_params(params), do: params

  defp put_default_source(changeset) do
    if is_nil(get_field(changeset, :source)),
      do: put_change(changeset, :source, ""),
      else: changeset
  end

  defp put_source_digest(changeset) do
    case {get_change(changeset, :source), get_change(changeset, :source_digest)} do
      {source, nil} when is_binary(source) ->
        put_change(changeset, :source_digest, Base.encode16(:crypto.hash(:md5, source), case: :lower))
      _ -> changeset
    end
  end

  defp generate_coverage(changeset) do
    case get_change(changeset, :coverage_lines) do
      nil -> changeset
      lines -> put_change(changeset, :coverage, compute_coverage(lines))
    end
  end

  defp set_previous_file(changeset),
    do: set_previous_file(changeset, job_for_changeset(changeset))
  defp set_previous_file(changeset, %Opencov.Job{previous_job_id: previous_job_id})
      when not is_nil(previous_job_id) do
    file = find_previous_file(previous_job_id, changeset.changes.name)
    set_previous_file(changeset, file)
  end
  defp set_previous_file(changeset, %Opencov.File{id: id, coverage: coverage}),
    do: change(changeset, previous_file_id: id, previous_coverage: coverage)
  defp set_previous_file(changeset, _), do: changeset

  defp job_for_changeset(changeset) do
    job_id = get_change(changeset, :job_id) || changeset.data.job_id
    Repo.get(Opencov.Job, job_id)
  end

  defp find_previous_file(previous_job_id, name) do
    File |> for_job(previous_job_id) |> with_name(name) |> Opencov.Repo.first
  end
end
