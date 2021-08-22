defprotocol JobGenerator do
  alias Librecov.Web.Schemas.Job
  @doc "Returns a Job based on a given input"
  @spec digest(term) :: {:ok, Job.t()}
  def digest(t)
  @fallback_to_any true
  @spec digest!(term) :: Job.t()
  def digest!(t)
end
