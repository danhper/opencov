# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.ContentFile do
  @moduledoc """
  Content File
  """

  @derive [Poison.Encoder]
  defstruct [
    :type,
    :encoding,
    :size,
    :name,
    :path,
    :content,
    :sha,
    :url,
    :git_url,
    :html_url,
    :download_url,
    :_links,
    :target,
    :submodule_git_url
  ]

  @type t :: %__MODULE__{
          :type => String.t(),
          :encoding => String.t(),
          :size => integer(),
          :name => String.t(),
          :path => String.t(),
          :content => String.t(),
          :sha => String.t(),
          :url => String.t(),
          :git_url => String.t() | nil,
          :html_url => String.t() | nil,
          :download_url => String.t() | nil,
          :_links => GitHubV3RESTAPI.Model.ContentTreeLinks.t(),
          :target => String.t() | nil,
          :submodule_git_url => String.t() | nil
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.ContentFile do
  import GitHubV3RESTAPI.Deserializer

  def decode(value, options) do
    value
    |> deserialize(:_links, :struct, GitHubV3RESTAPI.Model.ContentTreeLinks, options)
  end
end
