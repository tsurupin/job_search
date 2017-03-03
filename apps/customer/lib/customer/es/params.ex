defmodule Customer.Es.Params do
  import Customer.TypeConverter.Integer, only: [to_i: 1]

  @default_page_size 20

  def pager_option(options) do
    options = convert_keys(options)
    page = page(options[:page])
    %{
      page: page,
      per_page: @default_page_size,
      offset: offset(page),
      sort: options[:sort]
    }
  end

  defp convert_keys(options) do
    Enum.reduce(options, %{}, fn {k, v}, map ->
      Map.put(map, convert_to_atom(k), v)
    end)
  end

  defp convert_to_atom(str) when is_atom(str), do: str
  defp convert_to_atom(str), do: String.to_atom(str)

  defp page(page), do: max(page |> to_i, 1)

  defp offset(page, per_page \\ @default_page_size) do
     ((page - 1) * per_page)
  end

end
