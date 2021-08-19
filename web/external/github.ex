defmodule Opencov.External.GitHub do
  def add_user_info(user) do
    if user.github_access_token do
      Map.put(user, :github_info, get_user_info(user))
    else
      user
    end
  end

  def get_user_info(user) do
    if github_user = Opencov.External.GitHub.Cache.fetch_user(user) do
      github_user
    else
      fetch_user_info(user)
    end
  end

  defp fetch_user_info(user) do
    github_user = Opencov.External.GitHub.OAuth.get!("/user", user: user)
    Opencov.External.GitHub.Cache.save_user(Map.put(user, :github_info, github_user))
    github_user
  end

  defp make_request do
  end
end
