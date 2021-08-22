defprotocol SourceGenerator do
  alias Librecov.Web.Schemas.Job.SourceFile
  @doc "Returns a SourceFile based on a given input"
  @spec digest(term) :: {:ok, SourceFile.t()}
  def digest(t)
  @spec digest!(term) :: SourceFile.t()
  def digest!(t)
end
