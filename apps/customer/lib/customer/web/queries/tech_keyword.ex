defmodule Customer.Web.Query.TechKeyword do
  use Customer.Query, model: Customer.Web.TechKeyword
  alias Customer.Web.TechKeyword

  def pluck_with_names(repo, names, columns) do
    repo.all(pluck(with_names(names), columns))

  end

#  def pluck(query \\ TechKeyword, column) do
#    pluck_query(query, column)
#    |> Enum.map(&(&1[column]))
#  end

  defp with_names(names) do
    (from t in TechKeyword,
    where: t.name in ^names)
  end

  defp pluck(query \\ TechKeyword, columns) do
    from t in query, select: ^columns
  end
end
