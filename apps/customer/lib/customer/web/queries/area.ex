defmodule Customer.Web.Query.Area do
  use Customer.Query, model: Customer.Web.Area
  alias Customer.Web.Area

  def names(repo) do
    repo.all(names)
  end

  defp names do
    (from a in Area, select: a.name)
  end

end
