# NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
# https://openapi-generator.tech
# Do not edit the class manually.

defmodule GitHubV3RESTAPI.Model.InlineResponse200 do
  @moduledoc """

  """

  @derive [Poison.Encoder]
  defstruct [
    :current_user_url,
    :current_user_authorizations_html_url,
    :authorizations_url,
    :code_search_url,
    :commit_search_url,
    :emails_url,
    :emojis_url,
    :events_url,
    :feeds_url,
    :followers_url,
    :following_url,
    :gists_url,
    :hub_url,
    :issue_search_url,
    :issues_url,
    :keys_url,
    :label_search_url,
    :notifications_url,
    :organization_url,
    :organization_repositories_url,
    :organization_teams_url,
    :public_gists_url,
    :rate_limit_url,
    :repository_url,
    :repository_search_url,
    :current_user_repositories_url,
    :starred_url,
    :starred_gists_url,
    :topic_search_url,
    :user_url,
    :user_organizations_url,
    :user_repositories_url,
    :user_search_url
  ]

  @type t :: %__MODULE__{
          :current_user_url => String.t(),
          :current_user_authorizations_html_url => String.t(),
          :authorizations_url => String.t(),
          :code_search_url => String.t(),
          :commit_search_url => String.t(),
          :emails_url => String.t(),
          :emojis_url => String.t(),
          :events_url => String.t(),
          :feeds_url => String.t(),
          :followers_url => String.t(),
          :following_url => String.t(),
          :gists_url => String.t(),
          :hub_url => String.t(),
          :issue_search_url => String.t(),
          :issues_url => String.t(),
          :keys_url => String.t(),
          :label_search_url => String.t(),
          :notifications_url => String.t(),
          :organization_url => String.t(),
          :organization_repositories_url => String.t(),
          :organization_teams_url => String.t(),
          :public_gists_url => String.t(),
          :rate_limit_url => String.t(),
          :repository_url => String.t(),
          :repository_search_url => String.t(),
          :current_user_repositories_url => String.t(),
          :starred_url => String.t(),
          :starred_gists_url => String.t(),
          :topic_search_url => String.t() | nil,
          :user_url => String.t(),
          :user_organizations_url => String.t(),
          :user_repositories_url => String.t(),
          :user_search_url => String.t()
        }
end

defimpl Poison.Decoder, for: GitHubV3RESTAPI.Model.InlineResponse200 do
  def decode(value, _options) do
    value
  end
end
