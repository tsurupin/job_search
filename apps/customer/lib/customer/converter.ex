defprotocol Customer.Converter do
  def convert_key_to_atom(data)
end

defimpl Customer.Converter, for: Map do
  def convert_key_to_atom(map) do
    for {key, val} <- map, into: %{}, do: {convert(key), val}
  end

  defp convert(key) when is_atom(key), do: key
  defp convert(key) when is_binary(key), do: String.to_atom(key)
end