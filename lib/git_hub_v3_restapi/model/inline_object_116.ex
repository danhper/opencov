# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineObject116 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :name,
    :body
  ]

  @type t :: %__MODULE__{
          :name => String.t(),
          :body => String.t() | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineObject116 do
  def decode(value, _options) do
    value
  end
end
