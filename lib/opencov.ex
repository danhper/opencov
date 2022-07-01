defmodule Opencov do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      {Opencov.Endpoint, []},
      # Start the Ecto repository
      worker(OpenIDConnect.Worker, [Application.get_env(:opencov, :openid_connect_providers)]),
      {Opencov.Repo, []},

      {Phoenix.PubSub, [name: Opencov.PubSub, adapter: Phoenix.PubSub.PG2]}
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Opencov.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Opencov.Endpoint.config_change(changed, removed)
    :ok
  end

  defp openid_config() do
    config = Application.get_all_env(:openid)
    [
      # discovery_document_uri: "https://did.app/.well-known/openid-configuration",
      client_id: config[:client_id],
      client_secret: config[:client_secret],
      redirect_uri: config[:redirect_uri],
      response_type: "code",
      scope: "openid"
    ]
  end
end
