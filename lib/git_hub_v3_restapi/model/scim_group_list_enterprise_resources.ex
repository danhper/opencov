# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.ScimGroupListEnterpriseResources do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :schemas,
    :id,
    :externalId,
    :displayName,
    :members,
    :meta
  ]

  @type t :: %__MODULE__{
          :schemas => [String.t()],
          :id => String.t(),
          :externalId => String.t() | nil,
          :displayName => String.t() | nil,
          :members => [GitHubV3RESTAPI.Model.ScimGroupListEnterpriseMembers.t()] | nil,
          :meta => GitHubV3RESTAPI.Model.ScimGroupListEnterpriseMeta.t() | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.ScimGroupListEnterpriseResources do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:members, :list, GitHubV3RESTAPI.Model.ScimGroupListEnterpriseMembers, options)
    |> deserialize(:meta, :struct, GitHubV3RESTAPI.Model.ScimGroupListEnterpriseMeta, options)
  end
end
