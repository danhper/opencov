# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineObject163 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :armored_public_key
  ]

  @type t :: %__MODULE__{
          :armored_public_key => String.t()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineObject163 do
  def decode(value, _options) do
    value
  end
end
