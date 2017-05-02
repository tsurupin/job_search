defmodule Customer.Web.Query.JobTitle do
  use Customer.Query, model: Customer.Web.JobTitle
  alias Customer.Web.JobTitle

  def names(repo) do
    repo.all(names)
  end

  defp names do
    (from j in JobTitle, select: j.name)
  end

end
