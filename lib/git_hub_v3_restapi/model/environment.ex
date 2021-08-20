# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.Environment do
  @moduledoc """
  Details of a deployment environment
  """

  @derive [Poison.Encoder]
  defstruct [
    :id,
    :node_id,
    :name,
    :url,
    :html_url,
    :created_at,
    :updated_at,
    :protection_rules,
    :deployment_branch_policy
  ]

  @type t :: %__MODULE__{
          :id => integer(),
          :node_id => String.t(),
          :name => String.t(),
          :url => String.t(),
          :html_url => String.t(),
          :created_at => DateTime.t(),
          :updated_at => DateTime.t(),
          :protection_rules => [AnyOfobjectobjectobject] | nil,
          :deployment_branch_policy => GitHubV3RESTAPI.Model.DeploymentBranchPolicy.t() | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.Environment do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(
      :protection_rules,
      :list,
      GitHubV3RESTAPI.Model.AnyOfobjectobjectobject,
      options
    )
    |> deserialize(
      :deployment_branch_policy,
      :struct,
      GitHubV3RESTAPI.Model.DeploymentBranchPolicy,
      options
    )
  end
end
