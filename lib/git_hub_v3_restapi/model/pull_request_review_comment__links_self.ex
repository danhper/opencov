# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.PullRequestReviewCommentLinksSelf do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :href
  ]

  @type t :: %__MODULE__{
          :href => String.t()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.PullRequestReviewCommentLinksSelf do
  def decode(value, _options) do
    value
  end
end
