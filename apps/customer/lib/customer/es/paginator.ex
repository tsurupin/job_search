defmodule Customer.Es.Paginator do

  alias Customer.Es
  alias Customer.Repo

  import Ecto.Query

  defstruct [
    results: [],
    entries: [],
    page_number: 0,
    page_size: 0,
    prev_page: 0,
    next_page: 0,
    has_prev: false,
    has_next: false,
    total_entries: 0,
    total_pages: 0,
  ]

  def paginate(results, query), do: paginate(results, query, [])
  def paginate(%{error: _}, _query, _options), do: %__MODULE__{}
  def paginate(results, query, options) do
    opt = Es.Params.pager_option(options)
    page = opt[:page]
    page_size = opt[:per_page]
    pages = total_pages(results[:hits][:total], query)

    %__MODULE__{
      entries: entries(results[:hits][:hits], query),
      page_size: options[:page_size],
      page_number: page,
      total_entries: results[:hits][:total],
      total_pages: pages,
      results: results
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
      prev_page: map.page_number - 1,
      next_page: map.page_number + 1,
      has_prev: map.page_number > 1,
      has_next: map.page_number < map.total_pages
    }
  end

  defp entries(hits, query) do
    Enum.map(hits, fn(hit) ->
      query
      |> where([model], model.id == ^hit[:_id])
      |> Repo.one
    end)
  end

end
