# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineObject30 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :encrypted_value,
    :key_id,
    :visibility,
    :selected_repository_ids
  ]

  @type t :: %__MODULE__{
          :encrypted_value => String.t() | nil,
          :key_id => String.t() | nil,
          :visibility => String.t(),
          :selected_repository_ids => [String.t()] | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineObject30 do
  def decode(value, _options) do
    value
  end
end
