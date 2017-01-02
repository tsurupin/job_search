defmodule Customer.TypeConverter.Integer do
  def to_i(value) when is_integer(value), do: value
  def to_i(value) when is_float(value), do: round(value)
  def to_i(value) when is_nil(value), do: 0
  def to_i(value) do
    case Integer.parse(value) do
      :error -> 0
       {n, _} -> n
     end
  end
end
