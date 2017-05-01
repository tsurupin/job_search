#defmodule Customer.Web.Es.TechKeyrod do
# # for elastic search
#
#  def es_search_data(record) do
#    [
#      id: record.id,
#      name: record.name
#    ]
#  end
#
#  def es_reindex, do: Es.Index.reindex __MODULE__, Repo.all(__MODULE__)
#
#  def es_create_index(name \\ nil) do
#    index = [type: estype, index: esindex(name)]
#    Es.Schema.TechKeyword.completion(index)
#  end
#
#  def es_search(nil), do: nil
#  def es_search(word) do
#    word = String.downcase(word)
#
#    result =
#      Tirexs.DSL.define fn ->
#        import Tirexs.Search
#        require Tirexs.Query.Filter
#        search [index: esindex] do
#          query do
#            filtered do
#              query do
#                match_all([])
#              end
#              filter do
#                term "name", word
#              end
#            end
#          end
#        end
#      end
#
#
#    case result do
#      {_, _, map} -> map
#      r -> r
#    end
#  end
#end