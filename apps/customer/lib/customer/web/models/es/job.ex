defmodule Customer.Web.Es.Job do
  use Customer.Es
  alias Customer.Es
  alias Customer.Web.Job
  alias Customer.Web.Query

  def es_search_data(model) do
    model = Query.Job.get_with_associations(model.id)
    [
      job_id: model.id,
      job_title: String.downcase(model.job_title.name),
      detail: String.downcase(Map.get(model.detail, "value")),
      company_name: String.downcase(model.company.name),
      area: String.downcase(model.area.name),
      techs: Enum.map(model.tech_keywords, &(String.downcase(&1.name))),
      updated_at: Timex.format!(model.updated_at, "%Y-%m-%d", :strftime)
    ]
  end

  def es_reindex, do: Es.Index.reindex Job, Repo.all(Job)

  def es_create_index(name \\ nil) do
    index = [type: estype(Job), index: esindex(Job, name)]
    Es.Schema.Job.completion(index)
  end

  def es_search, do: es_search(nil, [])
  def es_search(params), do: es_search(params, [])
  def es_search(params, options) when params == %{},  do: es_search(nil, options)

  def es_search(params, options \\ %{page: 1}) do
    options = Map.merge(@default_options, options)
    result =
      Tirexs.DSL.define fn ->
        opt = Es.Params.pager_option(options)

        build_default_query(Map.take(opt, [:per_page, :offset]))
        |> add_filter_query(params)
        |> add_sort_query(opt[:sort])
        |> es_logging
      end

    case result do
      {_, _, map} -> map
      r -> r
    end
  end

  defp build_default_query(%{per_page: per_page, offset: offset}) do
    import Tirexs.Search
    require Tirexs.Query.Filter
    search [index: esindex(Job), from: offset, size: per_page] do
      query do
        filtered do
          query do
            match_all([])
          end
        end
      end
    end
  end


  defp add_filter_query(query, nil), do: query
  defp add_filter_query(query, params) do
     put_in query, [:search, :query, :filtered, :filter], Es.Filter.Job.perform(params)
  end

  defp add_sort_query(query, nil), do: query
  defp add_sort_query(query, sort) do
     put_in query, [:search, :sort], Es.Sort.perform(sort)
  end

  defp es_logging(query) do
    Es.Logger.ppdebug(query)
    query
  end

end