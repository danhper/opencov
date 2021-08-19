defmodule Opencov.GithubService do
  require Logger
  def handle("synchronize", payload) do
    pr = payload["pull_request"]
    IO.inspect(pr)
  end

  def handle(event, payload) do
    Logger.warn("Unhandled event: #{event}")
  end
end
