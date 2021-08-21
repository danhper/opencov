defmodule Librecov.CodecovController do
  use Librecov.Web, :controller
  alias Librecov.Web.ApiSpec

  # plug(Librecov.Plug.MultipartJob)
  # plug(OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true)

  def open_api_operation(:create), do: ApiSpec.spec().paths["/api/v1/jobs"].post

  alias Librecov.ProjectManager

  # def create(%{body_params: json} = conn, _) do
  #   handle_create(conn, json |> Jason.encode!() |> Jason.decode!())
  # end

  def v2(conn, params) do
    {:ok, data, _conn_details} = Plug.Conn.read_body(conn)

    {:ok, file_path} = Temp.open("my-file", &IO.write(&1, data))

    {result, code} =
      System.cmd(
        "#{File.cwd!()}/node_modules/.bin/lcov-parse",
        [file_path]
      )

    source_files = result |> Jason.decode!() |> Enum.map(&lcov_object_to_map/1)

    cv = %{
      service_name: "codecov-v2",
      repo_token: params["token"],
      source_files: source_files,
      git: %{
        head: %{
          id: params["commit"],
          author_name: "",
          author_email: "",
          committer_name: "",
          committer_email: "",
          message: ""
        },
        branch: params["branch"]
      }
    }

    project = ProjectManager.find_by_token!(params["token"])
    {:ok, {_, job}} = ProjectManager.add_job!(project, cv |> Jason.encode!() |> Jason.decode!())
    IO.inspect(conn)

    conn
    |> put_view(Librecov.Api.V1.JobView)
    |> render("show.json", job: job)
  end

  defp lcov_object_to_map(lcov_object) do
    IO.inspect(lcov_object["lines"])
    total_lines = lcov_object["lines"]["found"]

    %{
      name: lcov_object["file"],
      source: Range.new(1, total_lines) |> Enum.map(fn _ -> "MISSING" end) |> Enum.join("\n"),
      coverage: details_to_coverage(lcov_object["lines"]["details"], total_lines),
      branches: details_to_branches(lcov_object["branches"]["details"])
    }
  end

  defp details_to_coverage(details, total) do
    Range.new(1, total)
    |> Enum.map(fn line_no ->
      case details |> Enum.find(fn %{"line" => line} -> line == line_no end) do
        %{"hit" => hit} -> hit
        _ -> nil
      end
    end)

    details
    |> Enum.reduce([], fn %{"hit" => hit, "line" => line}, acc ->
      acc |> List.insert_at(line - 1, hit)
    end)
  end

  defp details_to_branches(details) do
    details
    |> Enum.map(fn branch ->
      [
        Map.get(branch, "line", 0),
        Map.get(branch, "block", 0),
        Map.get(branch, "branch", 0),
        Map.get(branch, "taken", 0)
      ]
    end)
  end

  defp handle_create(conn, %{"repo_token" => token} = params) do
    project = ProjectManager.find_by_token!(token)
    {:ok, {_, job}} = ProjectManager.add_job!(project, params)
    render(conn, "show.json", job: job)
  end
end
