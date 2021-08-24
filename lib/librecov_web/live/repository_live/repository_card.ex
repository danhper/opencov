defmodule Librecov.RepositoryLive.RepositoryCard do
  use Surface.Component
  alias Librecov.Router.Helpers, as: Routes

  import Librecov.CommonView
  alias Librecov.Project
  alias Surface.Components.Link

  def project_for_repo(projects, repository) do
    Enum.find(
      projects,
      %Project{current_coverage: nil, builds: []},
      &(&1.repo_id == "github_#{repository.id}")
    )
  end

  prop projects, :list, required: true
  prop repository, :struct, required: true

  def render(assigns) do
    repo = assigns.repository
    project = project_for_repo(assigns.projects, assigns.repository)
    latest_build = List.first(project.builds)

    latest_update =
      if(is_nil(latest_build),
        do: Timex.parse!(repo.updated_at, "{ISO:Extended:Z}"),
        else: latest_build.updated_at
      )

    topics = repo.topics || []

    ~F"""
    <div class="card m-2 p-0 col-5">
      <div class="card-body">
        <h5 class="card-title font-weight-bold">
          {#if !is_nil(project.id) }
          <Link
            class="text-dark"
            label={@repository.full_name}
            to={Routes.repository_show_path(@socket, :show, @repository.owner.login, @repository.name)}
          />
          <span class={"badge bg-#{coverage_badge(project.current_coverage)} badge-pill"}>{format_coverage(project.current_coverage)}</span>
          {#else}
          {@repository.full_name}
          <Link
            label="Setup"
            class="btn btn-sm btn-info font-weight-light"
            to={"#{@repository.html_url}/settings/installations"}
            opts={target: "_blank"}
          />
          {/if}
        </h5>
        <p class="card-text">{@repository.description}</p>
        {#if !is_nil(latest_build) && !is_nil(latest_build.commit_message) }
        <p class="card-text text-muted">

        <Link
            class="text-muted"
            label={latest_build.commit_message}
            to={Routes.build_path(@socket, :show, latest_build)}
          />
          {#if !is_nil(latest_build.branch) }
          on branch <span class="font-italic">{latest_build.branch}</span>
          {/if}
          </p>
        {/if}
        {#for item <- topics}
          <Link
            label={item}
            to={"https://github.com/topics/#{item}"}
            class="card-link btn btn-sml"
            opts={target: "_blank"}
          />
        {/for}
      </div>
      <div class="card-footer">
        <small class="text-muted"><i class="fas fa-code"></i> {repo.language} </small>
        <small class="text-muted"><i class="fas fa-history"></i> Updated {latest_update |> Timex.from_now()}</small>
      </div>
    </div>
    """
  end
end
