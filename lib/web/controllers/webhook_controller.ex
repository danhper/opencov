defmodule Librecov.WebhookController do
  use Librecov.Web, :controller
  alias Librecov.Web.ApiSpec
  alias Librecov.BuildManager

  plug(Librecov.Plug.MultipartJob)
  plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)

  def open_api_operation(:create), do: ApiSpec.spec().paths["/webhook"].post

  alias Librecov.ProjectManager

  def create(%{body_params: %{payload: %{build_num: build_num, status: "done"}} = body} = conn, _) do
    token = Map.get(body, :repo_token) || Map.get(conn.query_params, "repo_token")
    project = ProjectManager.find_by_token!(token)
    build = BuildManager.mark_as_complete!(build_num)
    ProjectManager.perform_github_integrations(project, build)
    render(conn, "show.json", build: build)
  end
end
