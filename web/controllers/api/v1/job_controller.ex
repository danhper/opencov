defmodule Api.V1.JobController do
  use Opencov.Web, :controller
  
  def create(conn, params) do
    IO.inspect params
    render conn, ok: "foo"
  end
end
