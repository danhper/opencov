# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.Enterprise do
  @moduledoc """
  An enterprise account
  """

  @derive [Poison.Encoder]
  defstruct [
    :description,
    :html_url,
    :website_url,
    :id,
    :node_id,
    :name,
    :slug,
    :created_at,
    :updated_at,
    :avatar_url
  ]

  @type t :: %__MODULE__{
          :description => String.t() | nil,
          :html_url => String.t(),
          :website_url => String.t() | nil,
          :id => integer(),
          :node_id => String.t(),
          :name => String.t(),
          :slug => String.t(),
          :created_at => DateTime.t() | nil,
          :updated_at => DateTime.t() | nil,
          :avatar_url => String.t()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.Enterprise do
  def decode(value, _options) do
    value
  end
end
