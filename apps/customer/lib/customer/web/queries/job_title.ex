defmodule Customer.Web.Query.JobTitle do
  use Customer.Query, model: Customer.Web.JobTitle
  alias Customer.Web.JobTitle

  def names do
    Repo.all(names_query)
  end

  defp names_query do
    (from j in JobTitle, select: j.name)
  end

end
