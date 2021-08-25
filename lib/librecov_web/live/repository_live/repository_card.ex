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
    <div class="block block-rounded block-bordered block-fx-pop">
      <div class="block-header block-header-default">
        <h3 class="block-title">
          {#if !is_nil(project.id) }
          <Link
            label={@repository.full_name}
            to={Routes.repository_show_path(@socket, :show, @repository.owner.login, @repository.name)}
          />
          {#else}
          {@repository.full_name}
          {/if}
        </h3>
        <div class="block-options">
          {#if is_nil(project.id) }
          <Link
            class="btn-block-option"
            to={"#{@repository.html_url}/settings/installations"}
            opts={target: "_blank"}
          ><i class="si si-settings"></i></Link>
          {/if}
        </div>
      </div>
      <div class={"block-content block-content-full ribbon ribbon-#{coverage_badge(project.current_coverage)} ribbon-bookmark"}>
        {#if !is_nil(project.id) }
        <div class="ribbon-box">
          {format_coverage(project.current_coverage)}
        </div>
        {/if}
        <p>{@repository.description}</p>
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
            class="badge rounded-pill bg-secondary"
            opts={target: "_blank"}
          />
        {/for}
      </div>
      <div class="block-content bg-light px-4 py-2 m-0">
        {#if !is_nil(repo.language) }
        <small class="text-muted pe-2"><i class="fas fa-code"></i> {repo.language} </small>
        {/if}
        <small class="text-muted"><i class="fas fa-history"></i> Updated {latest_update |> Timex.from_now()}</small>
      </div>
    </div>
    """
  end
end
