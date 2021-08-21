defmodule Librecov.Digest.CodecovV2 do
  require Logger
  alias Librecov.Parser.Lcov
  alias Librecov.Web.Schemas.CodecovV2.Parameters
  alias Librecov.Web.Schemas.Job

  def parameters_to_job(params) do
    %{
      service_name: params.service,
      repo_token: params.token,
      commit_sha: params.commit,
      flag_name: params.name,
      git: %{
        head: %{
          id: params.commit,
          committer_name: "",
          message: ""
        },
        branch: params.branch || ""
      },
      service_job_id: params.build,
      service_number: params.job,
      service_pull_request: params.pr,
      parallel: false,
      source_files: []
    }
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end

  defimpl SourceGenerator, for: BitString do
    alias Librecov.Digest.CodecovV2

    def digest(body) when is_binary(body) do
      [_file_structure | files] = body |> String.split("\n<<<<<< EOF\n")

      {:ok,
       files
       |> Enum.map(&CodecovV2.parse_uploaded_files/1)
       |> Enum.map(&CodecovV2.coverage_from_file/1)
       |> Enum.filter(&CodecovV2.valid_sourcefile/1)
       |> Enum.map(fn {:ok, files} -> files end)
       |> Enum.flat_map(fn files -> files |> Enum.group_by(&(&1.source_digest || &1.name)) end)
       |> Enum.map(fn {_, fs} ->
         fs |> Enum.reduce(&DeepMerge.deep_merge/2)
       end)
       |> Enum.map(&Map.from_struct/1)}
    end

    def digest!(body) do
      case digest(body) do
        {:ok, result} ->
          result

        e ->
          raise e
                |> Enum.map(fn e ->
                  OpenApiSpex.path_to_string(e) + "\n" + OpenApiSpex.error_message(e)
                end)
                |> Enum.join("\n\n")
      end
    end
  end

  defimpl JobGenerator, for: Parameters do
    alias Librecov.Digest.CodecovV2

    def digest(%Parameters{} = params) do
      Job.cast_and_validate(params |> CodecovV2.parameters_to_job())
    end

    def digest!(body) do
      case digest(body) do
        {:ok, result} ->
          result

        e ->
          raise e
                |> Enum.map(fn e ->
                  OpenApiSpex.path_to_string(e) + "\n" + OpenApiSpex.error_message(e)
                end)
                |> Enum.join("\n\n")
      end
    end
  end

  def valid_sourcefile({:ok, _}), do: true
  def valid_sourcefile(_), do: false

  def coverage_from_file(nil), do: {:error, :nil_input}

  def coverage_from_file([filename, content]) do
    if String.contains?(filename, "lcov") do
      Lcov.parse(content)
    else
      Logger.warn("Parsing of #{filename} not yet supported.")
      {:error, :not_parsed}
    end
  end

  def parse_uploaded_files(""), do: nil

  def parse_uploaded_files(file_str) do
    ["# path=" <> filename, file] = String.split(file_str, "\n", parts: 2)
    [filename, file]
  end
end
