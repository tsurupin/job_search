defmodule Customer.Es.Paginator do

  alias Customer.Es
  alias Customer.Repo

  import Ecto.Query

  defstruct [
    results: [],
    entries: [],
    page: 0,
    page_size: 0,
    prev_page: 0,
    next_page: 0,
    has_prev: false,
    has_next: false,
    total: 0,
    total_pages: 0,
  ]

  def paginate(results, %{query: query, options: options}), do: paginate(results, query, options)
  def paginate(results, query), do: paginate(results, query, %{})

  def paginate(%{error: _}, _query, _options), do: %__MODULE__{}
  def paginate(results, query, options) do
    opt = Es.Params.pager_option(options)
    page = opt[:page]
    page_size = opt[:per_page]

    pages = total_pages(results[:hits][:total], page_size)

    %__MODULE__{
      entries: entries(results[:hits][:hits]),
      page_size: options[:page_size],
      page: page,
      total_pages: pages,
      total: results[:hits][:total]
    }
    |> add_pagination_info
  end

  defp total_pages(total_entries, page_size) do
    ceiling(total_entries / page_size)
  end

  defp ceiling(float) do
    t = trunc(float)
    case float - t do
      neg when neg <= 0 -> t
      pos when pos > 0 -> t + 1
    end
  end

  defp add_pagination_info(map) do
    Map.merge map, %{
      prev_page: map.page - 1,
      next_page: map.page + 1,
      has_prev: map.page > 1,
      has_next: map.page < map.total_pages,
      total: map.total
    }
  end

  defp entries(hits) do
    Enum.map(hits, &(&1[:_source]))
  end

end
