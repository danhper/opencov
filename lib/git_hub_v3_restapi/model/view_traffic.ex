# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.ViewTraffic do
  @moduledoc """
  View Traffic
  """

  @derive [Poison.Encoder]
  defstruct [
    :count,
    :uniques,
    :views
  ]

  @type t :: %__MODULE__{
          :count => integer(),
          :uniques => integer(),
          :views => [GitHubV3RESTAPI.Model.Traffic.t()]
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.ViewTraffic do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:views, :list, GitHubV3RESTAPI.Model.Traffic, options)
  end
end
