defmodule Librecov do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    Logger.add_backend(Sentry.LoggerBackend)

    children = [
      {Mutex, name: LibreCov.JobLock},
      {Phoenix.PubSub, name: LibreCov.PubSub},
      # Start the endpoint when the application starts
      {Librecov.Endpoint, []},
      # Start the Ecto repository
      {Librecov.Repo, []}
      # Here you could define other workers and supervisors as children
      # worker(Librecov.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Librecov.Supervisor]
    s = Supervisor.start_link(children, opts)

    EventBus.subscribe({Librecov.Subscriber.BuildSubscriber, [:inserted, :updated]})
    EventBus.subscribe({Librecov.Subscriber.GithubSubscriber, [:build_finished]})

    s
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Librecov.Endpoint.config_change(changed, removed)
    :ok
  end
end
