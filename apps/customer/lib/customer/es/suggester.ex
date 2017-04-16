defmodule Customer.Es.Suggester do
  alias Customer.Repo

  def response(results) when is_nil(results), do: []
  def response(results) do
    Enum.map results[:hits][:hits], &(&1[:_source][:name])
  end

  def completion(model, word) do

    word
    |> String.trim
    |> String.split(~r/[,\.\s]/)
    |> List.first
    |> model.es_search
    |> response
  end

end
