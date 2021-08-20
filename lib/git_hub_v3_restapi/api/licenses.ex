# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Api.Licenses do
  @moduledoc """
  API calls for all endpoints tagged `Licenses`.
  """

  alias GitHubV3RESTAPI.Connection
  import GitHubV3RESTAPI.RequestBuilder

  @doc """
  Get a license

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - license (String.t): 
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.License.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec licenses_get(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:ok, GitHubV3RESTAPI.Model.License.t()}
          | {:error, Tesla.Env.t()}
  def licenses_get(connection, license, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/licenses/#{license}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.License{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false}
    ])
  end

  @doc """
  Get all commonly used licenses

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - opts (KeywordList): [optional] Optional parameters
    - :featured (boolean()): 
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%LicenseSimple{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec licenses_get_all_commonly_used(Tesla.Env.client(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.LicenseSimple.t())}
          | {:error, Tesla.Env.t()}
  def licenses_get_all_commonly_used(connection, opts \\ []) do
    optional_params = %{
      :featured => :query,
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/licenses")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.LicenseSimple{}]},
      {304, false}
    ])
  end

  @doc """
  Get the license for a repository
  This method returns the contents of the repository's license file, if one is detected.  Similar to [Get repository content](https://docs.github.com/rest/reference/repos#get-repository-content), this method also supports [custom media types](https://docs.github.com/rest/overview/media-types) for retrieving the raw license content or rendered license HTML.

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - owner (String.t): 
  - repo (String.t): 
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.LicenseContent.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec licenses_get_for_repo(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, GitHubV3RESTAPI.Model.LicenseContent.t()} | {:error, Tesla.Env.t()}
  def licenses_get_for_repo(connection, owner, repo, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/repos/#{owner}/#{repo}/license")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.LicenseContent{}}
    ])
  end
end
