defmodule Opencov.Integration.GithubController do
  use Opencov.Web, :controller

  alias Opencov.External.GitHub

  def new(conn, _params) do
    redirect conn, external: GitHub.OAuth.authorize_url!
  end

  def callback(conn, %{"code" => code}) do
    conn = case GitHub.OAuth.get_token(code: code) do
      {:ok, access_token} ->
        current_user(conn)
        |> Opencov.UserManager.github_changeset(access_token.access_token)
        |> Repo.update!
        conn
      {:error, error} ->
        put_flash(conn, :error, "GitHub failed with the following error: #{inspect(error)}")
    end
    redirect conn, to: integration_path(conn, :show)
  end

  def delete(conn, _params) do
    GitHub.Cache.delete_user(current_user(conn))
    current_user(conn)
    |> Opencov.UserManager.github_changeset(nil)
    |> Repo.update!
    redirect conn, to: integration_path(conn, :show)
  end
end
