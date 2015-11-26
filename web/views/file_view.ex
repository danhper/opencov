defmodule Opencov.FileView do
  use Opencov.Web, :view

  import Opencov.CommonView
  import Scrivener.HTML

  def filters do
    %{
      "changed" => "Changed",
      "cov_changed" => "Coverage changed",
      "covered" => "Covered",
      "unperfect" => "Unperfect"
    }
  end
end
