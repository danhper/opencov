# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Api.Gists do
  @moduledoc """
  API calls for all endpoints tagged `Gists`.
  """

  alias GitHubV3RESTAPI.Connection
  import GitHubV3RESTAPI.RequestBuilder

  @doc """
  Check if a gist is starred

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_check_is_starred(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, Map.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_check_is_starred(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/star")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {204, false},
      {404, false},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Create a gist
  Allows you to add a new gist with one or more files.  **Note:** Don't name your files \"gistfile\" with a numerical suffix. This is the format of the automatic naming scheme that Gist uses internally.

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - opts (KeywordList): [optional] Optional parameters
    - :body (InlineObject17): 
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistSimple.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_create(Tesla.Env.client(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.GistSimple.t()}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_create(connection, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    %{}
    |> method(:post)
    |> url("/gists")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {201, %GitHubV3RESTAPI.Model.GistSimple{}},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Create a gist comment

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :body (InlineObject18): 
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistComment.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_create_comment(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:ok, GitHubV3RESTAPI.Model.GistComment.t()}
          | {:error, Tesla.Env.t()}
  def gists_create_comment(connection, gist_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    %{}
    |> method(:post)
    |> url("/gists/#{gist_id}/comments")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {201, %GitHubV3RESTAPI.Model.GistComment{}},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Delete a gist

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_delete(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, GitHubV3RESTAPI.Model.BasicError.t()} | {:error, Tesla.Env.t()}
  def gists_delete(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/gists/#{gist_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {204, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Delete a gist comment

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - comment_id (integer()): comment_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_delete_comment(Tesla.Env.client(), String.t(), integer(), keyword()) ::
          {:ok, nil} | {:ok, GitHubV3RESTAPI.Model.BasicError.t()} | {:error, Tesla.Env.t()}
  def gists_delete_comment(connection, gist_id, comment_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/gists/#{gist_id}/comments/#{comment_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {204, false},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Fork a gist
  **Note**: This was previously `/gists/:gist_id/fork`.

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.BaseGist.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_fork(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.BaseGist.t()}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_fork(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:post)
    |> url("/gists/#{gist_id}/forks")
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {201, %GitHubV3RESTAPI.Model.BaseGist{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Get a gist

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistSimple.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_get(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.GistSimple.t()}
          | {:ok, GitHubV3RESTAPI.Model.InlineResponse403.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_get(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.GistSimple{}},
      {403, %GitHubV3RESTAPI.Model.InlineResponse403{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false}
    ])
  end

  @doc """
  Get a gist comment

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - comment_id (integer()): comment_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistComment.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_get_comment(Tesla.Env.client(), String.t(), integer(), keyword()) ::
          {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.InlineResponse403.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:ok, GitHubV3RESTAPI.Model.GistComment.t()}
          | {:error, Tesla.Env.t()}
  def gists_get_comment(connection, gist_id, comment_id, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/comments/#{comment_id}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.GistComment{}},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.InlineResponse403{}}
    ])
  end

  @doc """
  Get a gist revision

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - sha (String.t): 
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistSimple.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_get_revision(Tesla.Env.client(), String.t(), String.t(), keyword()) ::
          {:ok, GitHubV3RESTAPI.Model.GistSimple.t()}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_get_revision(connection, gist_id, sha, _opts \\ []) do
    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/#{sha}")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.GistSimple{}},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List gists for the authenticated user
  Lists the authenticated user's gists or if called anonymously, this endpoint returns all public gists:

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - opts (KeywordList): [optional] Optional parameters
    - :since (DateTime.t): Only show notifications updated after the given time. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%BaseGist{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list(Tesla.Env.client(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.BaseGist.t())}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list(connection, opts \\ []) do
    optional_params = %{
      :since => :query,
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.BaseGist{}]},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List gist comments

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%GistComment{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_comments(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.GistComment.t())}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_comments(connection, gist_id, opts \\ []) do
    optional_params = %{
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/comments")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.GistComment{}]},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List gist commits

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%GistCommit{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_commits(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.GistCommit.t())}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_commits(connection, gist_id, opts \\ []) do
    optional_params = %{
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/commits")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.GistCommit{}]},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List gists for a user
  Lists public gists for the specified user:

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - username (String.t): 
  - opts (KeywordList): [optional] Optional parameters
    - :since (DateTime.t): Only show notifications updated after the given time. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%BaseGist{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_for_user(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, list(GitHubV3RESTAPI.Model.BaseGist.t())}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_for_user(connection, username, opts \\ []) do
    optional_params = %{
      :since => :query,
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/users/#{username}/gists")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.BaseGist{}]},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}}
    ])
  end

  @doc """
  List gist forks

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%GistSimple{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_forks(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, list(GitHubV3RESTAPI.Model.GistSimple.t())}
          | {:ok, nil}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_forks(connection, gist_id, opts \\ []) do
    optional_params = %{
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists/#{gist_id}/forks")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.GistSimple{}]},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List public gists
  List public gists sorted by most recently updated to least recently updated.  Note: With [pagination](https://docs.github.com/rest/overview/resources-in-the-rest-api#pagination), you can fetch up to 3000 gists. For example, you can fetch 100 pages with 30 gists per page or 30 pages with 100 gists per page.

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - opts (KeywordList): [optional] Optional parameters
    - :since (DateTime.t): Only show notifications updated after the given time. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%BaseGist{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_public(Tesla.Env.client(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.BaseGist.t())}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_public(connection, opts \\ []) do
    optional_params = %{
      :since => :query,
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists/public")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.BaseGist{}]},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  List starred gists
  List the authenticated user's starred gists:

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - opts (KeywordList): [optional] Optional parameters
    - :since (DateTime.t): Only show notifications updated after the given time. This is a timestamp in [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) format: `YYYY-MM-DDTHH:MM:SSZ`.
    - :per_page (integer()): Results per page (max 100)
    - :page (integer()): Page number of the results to fetch.
  ## Returns

  {:ok, [%BaseGist{}, ...]} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_list_starred(Tesla.Env.client(), keyword()) ::
          {:ok, nil}
          | {:ok, list(GitHubV3RESTAPI.Model.BaseGist.t())}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_list_starred(connection, opts \\ []) do
    optional_params = %{
      :since => :query,
      :per_page => :query,
      :page => :query
    }

    %{}
    |> method(:get)
    |> url("/gists/starred")
    |> add_optional_params(optional_params, opts)
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, [%GitHubV3RESTAPI.Model.BaseGist{}]},
      {401, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Star a gist
  Note that you'll need to set `Content-Length` to zero when calling out to this endpoint. For more information, see \"[HTTP verbs](https://docs.github.com/rest/overview/resources-in-the-rest-api#http-verbs).\"

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_star(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, GitHubV3RESTAPI.Model.BasicError.t()} | {:error, Tesla.Env.t()}
  def gists_star(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:put)
    |> url("/gists/#{gist_id}/star")
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {204, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {304, false},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Unstar a gist

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
  ## Returns

  {:ok, nil} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_unstar(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, nil} | {:ok, GitHubV3RESTAPI.Model.BasicError.t()} | {:error, Tesla.Env.t()}
  def gists_unstar(connection, gist_id, _opts \\ []) do
    %{}
    |> method(:delete)
    |> url("/gists/#{gist_id}/star")
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {204, false},
      {304, false},
      {404, %GitHubV3RESTAPI.Model.BasicError{}},
      {403, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Update a gist
  Allows you to update or delete a gist file and rename gist files. Files from the previous version of the gist that aren't explicitly changed during an edit are unchanged.

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :body (UNKNOWN_BASE_TYPE): 
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistSimple.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_update(Tesla.Env.client(), String.t(), keyword()) ::
          {:ok, GitHubV3RESTAPI.Model.GistSimple.t()}
          | {:ok, GitHubV3RESTAPI.Model.ValidationError.t()}
          | {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:error, Tesla.Env.t()}
  def gists_update(connection, gist_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    %{}
    |> method(:patch)
    |> url("/gists/#{gist_id}")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.GistSimple{}},
      {422, %GitHubV3RESTAPI.Model.ValidationError{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end

  @doc """
  Update a gist comment

  ## Parameters

  - connection (GitHubV3RESTAPI.Connection): Connection to server
  - gist_id (String.t): gist_id parameter
  - comment_id (integer()): comment_id parameter
  - opts (KeywordList): [optional] Optional parameters
    - :body (InlineObject19): 
  ## Returns

  {:ok, GitHubV3RESTAPI.Model.GistComment.t} on success
  {:error, Tesla.Env.t} on failure
  """
  @spec gists_update_comment(Tesla.Env.client(), String.t(), integer(), keyword()) ::
          {:ok, GitHubV3RESTAPI.Model.BasicError.t()}
          | {:ok, GitHubV3RESTAPI.Model.GistComment.t()}
          | {:error, Tesla.Env.t()}
  def gists_update_comment(connection, gist_id, comment_id, opts \\ []) do
    optional_params = %{
      :body => :body
    }

    %{}
    |> method(:patch)
    |> url("/gists/#{gist_id}/comments/#{comment_id}")
    |> add_optional_params(optional_params, opts)
    |> ensure_body()
    |> Enum.into([])
    |> (&Connection.request(connection, &1)).()
    |> evaluate_response([
      {200, %GitHubV3RESTAPI.Model.GistComment{}},
      {404, %GitHubV3RESTAPI.Model.BasicError{}}
    ])
  end
end
