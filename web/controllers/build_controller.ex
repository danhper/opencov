defmodule Opencov.BuildController do
  use Opencov.Web, :controller

  alias Opencov.Build

  def show(conn, %{"id" => id}) do
    build = Repo.get!(Build, id) |> Repo.preload(:jobs)
    render(conn, "show.html", build: build)
  end
end
