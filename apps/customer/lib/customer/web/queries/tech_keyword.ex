defmodule Customer.Web.Query.TechKeyword do
  use Customer.Query, model: Customer.Web.TechKeyword
  alias Customer.Web.TechKeyword

  def pluck_by_names(repo, names, column) when is_atom(column) do
    pluck([column], by_names(names))
    |> repo.all
    |> Enum.map(&(Map.values(&1)))
    |> List.flatten
  end

  defp by_names(names, query \\ TechKeyword) do
    (from t in query,
    where: t.name in ^names)
  end

  defp pluck(columns, query \\ TechKeyword) do
    from t in query, select: map(t, ^columns)
  end
end
