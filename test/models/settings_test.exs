defmodule Opencov.SettingsTest do
  use Opencov.ModelCase

  alias Opencov.Settings

  test "get_url_mapping returns correct mapping" do
    assert Settings.get_mapping(%Settings{url_mapping: ""}) == []

    mapping_left = "example.com/$project/repos/$repo"
    mapping_right = "example.com/$project/repos/$repo/commits/$hash"
    mapping = "#{mapping_left} #{mapping_right}"
    regexp = ~r{example.com/(?<project>[^/]+)/repos/(?<repo>[^/]+)}
    mapped = Settings.get_mapping(%Settings{url_mapping: mapping})
    assert Enum.count(mapped) == 1
    assert [%{regexp: actual_regexp, commit_url: commit_url}] = mapped
    assert mapping_right == commit_url
    assert actual_regexp.source == regexp.source
  end
end
