defmodule Librecov.Api.V1.JobController do
  use Librecov.Web, :controller
  alias Librecov.Web.ApiSpec

  plug(Librecov.Plug.MultipartJob)
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)

  def open_api_operation(:create), do: ApiSpec.spec().paths["/api/v1/jobs"].post

  alias Librecov.ProjectManager

  def create(%{body_params: json} = conn, _) do
    handle_create(conn, json |> Jason.encode!() |> Jason.decode!())
  end

  defp handle_create(conn, %{"repo_token" => token} = params) do
    project = ProjectManager.find_by_token!(token)
    {:ok, {_, job}} = ProjectManager.add_job!(project, params)
    render(conn, "show.json", job: job)
  end
end
