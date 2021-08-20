defmodule Librecov.Project do
  use Librecov.Web, :model

  import Ecto.Query

  schema "projects" do
    field(:name, :string)
    field(:token, :string)
    field(:current_coverage, :float)
    field(:base_url, :string)
    field(:repo_id, :string)

    belongs_to(:user, Librecov.User)
    has_many(:builds, Librecov.Build)
    has_one(:badge, Librecov.Badge)

    timestamps()
  end

  def with_token(query, token) do
    query |> where(token: ^token)
  end

  def visibility_choices do
    ~w(public private internal)
  end

  def name_and_owner(%Librecov.Project{name: name}) do
    [owner, name] = name |> String.split("/")
    {owner, name}
  end
end
