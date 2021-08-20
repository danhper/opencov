# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.ScimGroupListEnterprise do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :schemas,
    :totalResults,
    :itemsPerPage,
    :startIndex,
    :Resources
  ]

  @type t :: %__MODULE__{
          :schemas => [String.t()],
          :totalResults => float(),
          :itemsPerPage => float(),
          :startIndex => float(),
          :Resources => [GitHubV3RESTAPI.Model.ScimGroupListEnterpriseResources.t()]
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.ScimGroupListEnterprise do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :Resources,
      :list,
      GitHubV3RESTAPI.Model.ScimGroupListEnterpriseResources,
      options
    )
  end
end
