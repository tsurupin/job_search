#defmodule Customer.Web.Query.TechKeyword do
#  use Customer.Query, model: Customer.Web.TechKeyword
#  alias Customer.Web.TechKeyword
#
#  def pluck(query \\ __MODULE__, column) do
#      TechKeyword.pluck(query, column)
#    |> Repo.all
#    |> Enum.map(&(&1[column]))
#  end
#
#  def by_names(names) do
#      from t in __MODULE__,
#      where: t.name in ^names
#    end
#
#    def pluck(query \\ __MODULE__, column) do
#      from(t in query, select: map(t, [column]))
#    end
#end
