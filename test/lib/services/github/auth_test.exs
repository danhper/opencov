defmodule Opencov.Services.Github.AuthTest do
  use ExUnit.Case

  import Mock

  alias Opencov.Services.Github.Auth

  @installations_mocks [
    %ExOctocat.Model.Installation{
      access_tokens_url: "https://api.github.com/app/installations/18960408/access_tokens",
      account: %ExOctocat.Model.SimpleUser{
        avatar_url: "https://avatars.githubusercontent.com/u/1848186?v=4",
        email: nil,
        events_url: "https://api.github.com/users/yknx4/events{/privacy}",
        followers_url: "https://api.github.com/users/yknx4/followers",
        following_url: "https://api.github.com/users/yknx4/following{/other_user}",
        gists_url: "https://api.github.com/users/yknx4/gists{/gist_id}",
        gravatar_id: "",
        html_url: "https://github.com/yknx4",
        id: 1_848_186,
        login: "yknx4",
        name: nil,
        node_id: "MDQ6VXNlcjE4NDgxODY=",
        organizations_url: "https://api.github.com/users/yknx4/orgs",
        received_events_url: "https://api.github.com/users/yknx4/received_events",
        repos_url: "https://api.github.com/users/yknx4/repos",
        site_admin: false,
        starred_at: nil,
        starred_url: "https://api.github.com/users/yknx4/starred{/owner}{/repo}",
        subscriptions_url: "https://api.github.com/users/yknx4/subscriptions",
        type: "User",
        url: "https://api.github.com/users/yknx4"
      },
      app_id: 133_119,
      app_slug: "yknxopencov",
      contact_email: nil,
      created_at: "2021-08-19T18:22:24.000Z",
      events: ["pull_request", "push", "repository", "status"],
      has_multiple_single_files: false,
      html_url: "https://github.com/settings/installations/18960408",
      id: 18_960_408,
      permissions: %ExOctocat.Model.AppPermissions{
        actions: "read",
        administration: nil,
        checks: "write",
        content_references: nil,
        contents: "read",
        deployments: nil,
        environments: nil,
        issues: nil,
        members: nil,
        metadata: "read",
        organization_administration: nil,
        organization_hooks: nil,
        organization_packages: nil,
        organization_plan: nil,
        organization_projects: nil,
        organization_secrets: nil,
        organization_self_hosted_runners: nil,
        organization_user_blocking: nil,
        packages: nil,
        pages: nil,
        pull_requests: "read",
        repository_hooks: nil,
        repository_projects: nil,
        secret_scanning_alerts: nil,
        secrets: nil,
        security_events: nil,
        single_file: nil,
        statuses: "read",
        team_discussions: nil,
        vulnerability_alerts: nil,
        workflows: nil
      },
      repositories_url: "https://api.github.com/installation/repositories",
      repository_selection: "all",
      single_file_name: nil,
      single_file_paths: [],
      suspended_at: nil,
      suspended_by: nil,
      target_id: 1_848_186,
      target_type: "User",
      updated_at: "2021-08-19T21:26:27.000Z"
    }
  ]

  @token_mock %ExOctocat.Model.InstallationToken{
    expires_at: "2021-08-20T00:51:16Z",
    has_multiple_single_files: nil,
    permissions: %ExOctocat.Model.AppPermissions{
      actions: "read",
      administration: nil,
      checks: "write",
      content_references: nil,
      contents: "read",
      deployments: nil,
      environments: nil,
      issues: nil,
      members: nil,
      metadata: "read",
      organization_administration: nil,
      organization_hooks: nil,
      organization_packages: nil,
      organization_plan: nil,
      organization_projects: nil,
      organization_secrets: nil,
      organization_self_hosted_runners: nil,
      organization_user_blocking: nil,
      packages: nil,
      pages: nil,
      pull_requests: "read",
      repository_hooks: nil,
      repository_projects: nil,
      secret_scanning_alerts: nil,
      secrets: nil,
      security_events: nil,
      single_file: nil,
      statuses: "read",
      team_discussions: nil,
      vulnerability_alerts: nil,
      workflows: nil
    },
    repositories: nil,
    repository_selection: "all",
    single_file: nil,
    single_file_paths: nil,
    token: "ghs_XXXXXXXXXXwdPBAHVU7xiBgWROqIB2z3rWxKS"
  }

  test "generates app jwt token" do
    token = Auth.app_token()
    {:ok, claims} = Joken.peek_claims(token)
    assert Map.has_key?(claims, "iss")
    assert Map.has_key?(claims, "exp")
    assert Map.has_key?(claims, "iat")
  end

  test "make badge in other format" do
    with_mock ExOctocat.Api.Apps,
      apps_list_installations: fn _ ->
        {:ok, @installations_mocks}
      end,
      apps_create_installation_access_token: fn _, _ ->
        {:ok, @token_mock}
      end do
      assert is_nil(Auth.login_token("invalid"))
      assert Auth.login_token("yknx4") == {:ok, "ghs_XXXXXXXXXXwdPBAHVU7xiBgWROqIB2z3rWxKS"}
    end
  end
end
