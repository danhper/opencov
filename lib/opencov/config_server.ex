defmodule Opencov.ConfigServer do
  @doc """
  Runtime configuration server
  NOTE: this updates config/runtime.exs to store configuration, so it is only good for
  a single node.
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: default_name)
  end

  def default_name do
    ConfigServer
  end

  def set(key, value) do
    GenServer.cast(default_name, {:set, key, value})
  end

  def set(config) do
    GenServer.cast(default_name, {:set, config})
  end

  def init(_) do
    config = Application.get_env(:opencov, :runtime, [])
    config_path = Application.get_env(:opencov, :runtime_config_path)
    {:ok, {config, config_path}}
  end

  def handle_cast({:set, key, value}, {config, config_path}) do
    config = Keyword.put(config, key, value)
    persist_config(config, config_path)
    {:noreply, {config, config_path}}
  end

  def handle_cast({:set, new_config}, {config, config_path}) do
    config = Keyword.merge(config, new_config)
    persist_config(config, config_path)
    {:noreply, {config, config_path}}
  end

  defp persist_config(config, config_path) do
    Mix.Config.persist([opencov: [runtime: config]])
    File.write!(config_path, serialize_config(config))
  end

  def serialize_config(config) do
    values = Enum.map(config, fn {k, v} -> "#{k}: #{inspect(v)}" end) |> Enum.join(",\n  ")
    "use Mix.Config\n\nconfig :opencov, :runtime,\n  #{values}"
  end
end
