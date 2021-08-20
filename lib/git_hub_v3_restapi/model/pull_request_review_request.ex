# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.PullRequestReviewRequest do
  @moduledoc """
  Pull Request Review Request
  """

  @derive [Poison.Encoder]
  defstruct [
    :users,
    :teams
  ]

  @type t :: %__MODULE__{
          :users => [GitHubV3RESTAPI.Model.SimpleUser.t()],
          :teams => [GitHubV3RESTAPI.Model.Team.t()]
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.PullRequestReviewRequest do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:users, :list, GitHubV3RESTAPI.Model.SimpleUser, options)
    |> deserialize(:teams, :list, GitHubV3RESTAPI.Model.Team, options)
  end
end
