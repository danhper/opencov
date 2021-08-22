defmodule Librecov.Helpers.JobLogger do
  require Logger
  alias Librecov.Web.Schemas.Job

  def log_query(conn) do
    Logger.info("params: #{conn.query_params |> Jason.encode!(pretty: true)}")
  end

  def log(%Job{} = job) do
    Logger.info(
      "job: #{job |> Map.from_struct() |> Map.delete(:source_files) |> Jason.encode!(pretty: true)}"
    )
  end
end
