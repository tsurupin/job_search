defmodule Customer.Es.Index do
  import Tirexs.Manage.Aliases
  alias Tirexs.HTTP
  alias Tirexs.Resources
  alias Tirexs.Resources.Indices

  alias Customer.Blank
  alias Customer.Es

  def name_type(model) do
    model
    |> to_string
    |> String.downcase
  end

  def name_index(model) do
    "es_#{name_type(model)}"
  end

  def name_reindex(index) do
    "#{index}_#{time_suffix}"
  end

  def reindex(model), do: reindex(model, nil)
  def reindex(model, data) do
    index = name_index(model)
    new_index = name_reindex(index)

    case get_aliases(index) do
      nil ->
        upsert_index(model, index, data, new_index)
      old_index ->
        upsert_index(model, index, data, new_index, old_index)
        HTTP.delete("#{old_index}")
    end
    :ok
  end

  defp time_suffix do
    Timex.now |> Timex.format!("%Y%m%d%H%M%S%f", :strftime)
  end

  defp upsert_index(model, index, data, new_index, old_index \\ nil) do
    model.es_create_index(new_index)
    unless Blank.blank?(data) do


       case Es.Document.put_document(data, new_index) do
         :ok -> upsert_aliases(aliase_query(index, new_index, old_index))
         error -> IO.inspect error

       end
    end
  end

  defp upsert_aliases(alias_query) do
    Es.Logger.ppdebug alias_query
    Resources.bump(alias_query)._aliases
  end

  defp aliase_query(index, new_index, old_index) do
    aliases do
      add index: new_index, alias: index
      if old_index, do: remove index: old_index, alias: index
    end
  end

  defp get_aliases(index) do
    case HTTP.get(Indices._aliases(index)) do
      {:ok, _, map} ->
        map
        |> Dict.keys
        |> List.first
        |> to_string
      _ -> nil
    end
  end
end
