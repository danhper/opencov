# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineResponse415 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :message,
    :documentation_url
  ]

  @type t :: %__MODULE__{
          :message => String.t(),
          :documentation_url => String.t()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineResponse415 do
  def decode(value, _options) do
    value
  end
end
