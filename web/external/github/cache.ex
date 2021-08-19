defmodule Opencov.External.GitHub.Cache do
  use GenServer

  @ttl 30 * 60

  def start_link do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, %{users: %{}}}
  end

  def save_user(user) do
    GenServer.cast(__MODULE__, {:save_user, user})
  end

  def delete_user(user) do
    GenServer.cast(__MODULE__, {:delete_user, user})
  end

  def fetch_user(user) do
    case GenServer.call(__MODULE__, {:fetch_user, user}) do
      {:ok, github_user} -> github_user
      :error -> nil
    end
  end

  def handle_cast({:save_user, user}, state) do
    expire = DateTime.to_unix(DateTime.utc_now) + @ttl
    new_state = put_in(state, [:users, user.id], {user.github_info, expire})
    {:noreply, new_state}
  end

  def handle_cast({:delete_user, user}, state) do
    {:noreply, pop_in(state, [:users, user.id]) |> elem(1)}
  end

  def handle_call({:fetch_user, user}, _from, state) do
    current_timestamp = DateTime.to_unix(DateTime.utc_now)
    case state.users[user.id] do
      nil ->
        {:reply, :error, state}
      {_github_user, expires_at} when expires_at < current_timestamp ->
        {:reply, :error, pop_in(state, [:users, user.id]) |> elem(1)}
      {github_user, expires_at} when expires_at >= current_timestamp ->
        {:reply, {:ok, github_user}, state}
    end
  end
end
