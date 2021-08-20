# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.ProtectedBranchAdminEnforced do
  @moduledoc """
  Protected Branch Admin Enforced
  """

  @derive [Poison.Encoder]
  defstruct [
    :url,
    :enabled
  ]

  @type t :: %__MODULE__{
          :url => String.t(),
          :enabled => boolean()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.ProtectedBranchAdminEnforced do
  def decode(value, _options) do
    value
  end
end
