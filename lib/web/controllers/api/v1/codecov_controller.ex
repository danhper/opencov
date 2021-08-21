defmodule Librecov.CodecovController do
  use Librecov.Web, :controller
  alias Librecov.Web.ApiSpec
  alias Librecov.Digest.CodecovV2
  alias Librecov.Web.Schemas.CodecovV2.Parameters
  alias Librecov.Web.Schemas.Job

  plug(Librecov.Plug.PlainText)
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)

  def open_api_operation(:v2), do: ApiSpec.spec().paths["/upload/v2"].post

  alias Librecov.ProjectManager

  def v2(conn, params) do
    source_files = SourceGenerator.digest!(conn.body_params)

    job_definition = JobGenerator.digest!(params |> Parameters.cast_and_validate!())

    job_definition = %Job{job_definition | source_files: source_files}

    project = ProjectManager.find_by_token!(params.token)

    {:ok, {_, job}} =
      ProjectManager.add_job!(project, job_definition |> Jason.encode!() |> Jason.decode!())

    conn
    |> put_view(Librecov.Api.V1.JobView)
    |> render("show.json", job: job)
  end
end
