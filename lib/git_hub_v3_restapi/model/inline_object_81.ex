# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineObject81 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :state,
    :target_url,
    :log_url,
    :description,
    :environment,
    :environment_url,
    :auto_inactive
  ]

  @type t :: %__MODULE__{
          :state => String.t(),
          :target_url => String.t() | nil,
          :log_url => String.t() | nil,
          :description => String.t() | nil,
          :environment => String.t() | nil,
          :environment_url => String.t() | nil,
          :auto_inactive => boolean() | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineObject81 do
  def decode(value, _options) do
    value
  end
end
