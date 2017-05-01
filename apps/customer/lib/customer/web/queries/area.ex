defmodule Customer.Web.Query.Area do
  use Customer.Query, model: Customer.Web.Area
  alias Customer.Web.Area

  def names do
    names(Customer.Repo, Area)
  end

  def names(repo, area) do
    repo.all((from a in area, select: a.name))
  end

end
