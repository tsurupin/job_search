defmodule Customer.Es.Index do
  import Tirexs.Manage.Aliases
  alias Tirexs.HTTP
  alias Tirexs.Resources
  alias Tirexs.Resources.Indices

  alias Customer.Blank
  alias Customer.Es

  def name_index(model) do
    index =
      model
      |> to_string
      |> String.downcase

    "es_#{index}"
  end

  def name_type(model) do
    model
    |> to_string
    |> String.downcase
  end

  def name_reindex(index) do
    suffix =
      Timex.now
      |> Timex.format!("%Y%%m%d%H%M%S%f", :strftime)

    "#{index}_#{suffix}"
  end

  def reindex(model), do: reindex(model, nil)
  def reindex(model, data) do
    index = name_index(model)
    new_index = name_reindex(index)
    case get_aliases(index) do
      nil ->
        create_index(model, index, new_index, data)
      old_index ->
        update_index(model, index, new_index, old_index, data)
        HTTP.delete("#{old_index}")
    end

    :ok
  end

  defp update_index(model, index, new_index, old_index, data) do
    model.create_es_index(new_index)
    unless Blank.blank?(data), do: Es.Document.put_document(data, new_index)

    alias_query =
      (aliases do
        remove index: old_index, alias: index
        add index: new_index, alias: index
      end)
    Es.Logger.ppdebug alias_query
    Resources.bump(alias_query)._aliases

    HTTP.delete("#{old_index}")
  end

  defp create_index(model, index, new_index, data) do
    model.create_es_index(new_index)
    unless Blank.blank?(data), do: Es.Document.put_document(data, new_index)

    alias_query =
      (aliases do
        add index: new_index, alias: index
      end)
    Es.Logger.ppdebug alias_query
    Resources.bump(alias_query)._aliases
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
