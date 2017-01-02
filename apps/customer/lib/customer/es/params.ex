defmodule Customer.Es.Params do
  import Customer.TypeConverter.Integer, only: [to_i: 1]

  @default_page 1
  @default_page_size 20

  def pager_option(options) do
    options = options_with_convert_keys(options)
    page = page(options[:page])
    per_page = per_page(options[:limit], options[:per_page], options[:page_size])
    %{
      page: page,
      per_page: per_page,
      offset: offset(options[:offset], page, per_page),
      filter: options[:filter],
      sort: options[:sort],
    }
  end

  defp options_with_convert_keys(options) do
    Enum.reduce(options, %{}, fn {k, v}, map ->
      unless is_atom(k), do: k = String.to_atom(k)
      Map.put(map, k, v)
    end)
  end

  defp page(page) do
    max(page |> to_i, @default_page)
  end

  defp per_page(limit, per_page, page_size) do
    limit ||  per_page || page_size || @default_page_size
  end

  defp offset(offset, page, per_page) do
     offset || (page - 1) * per_page
  end

end
