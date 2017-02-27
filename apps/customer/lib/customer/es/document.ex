defmodule Customer.Es.Document do
  import Tirexs.Bulk
  alias Customer.Es
  alias Customer.Blank

  def put_document([]), do: :error
  def put_document(records) when is_list(records) do
    put_document records, index_name(records)
  end

  def put_document(%{} = record) do
     put_document record, index_name(record)
  end

  def put_document(%{} = model, name) do
    put_document [model], name
  end

  def put_document(records, name) when is_list(records) do
    put_document records, name, List.first(records).__struct__
  end

  def put_document([], _name), do: :error

  def put_document(records, name) do
    put_document records, name, index_name(List.first(Enum.take(records, 1)))
  end

  def put_document(records, name, model_name) do
    change_document(:index, records, name, model_name)
  end

  def delete_document([]), do: :error

  def delete_document(records) when is_list(records) do
    delete_document records, index_name(records)
  end

  def delete_document(%{} = record) do
    delete_document record, index_name(record)
  end

  def delete_document(%{} = record, name) do
    delete_document [record], name
  end

  def delete_document(records, name) when is_list(records) do
    delete_document records, name, List.first(records).__struct__
  end

  def delete_document([], _name), do: :error

  def delete_document(records, name) do
    delete_document records, name, index_name(List.first(Enum.take(records, 1)))
  end

  def delete_document(records, name, model_name) do
    change_document(:delete, records, name, model_name)
  end

  defp change_document(type, records, name, model) do

    records
    |> Stream.map(&model.es_search_data(&1))
    |> Stream.filter(fn item -> !Blank.blank?(item) end)
    |> Stream.chunk(50_000, 50_000, [])
    |> Stream.each(fn data ->

      payload =
        bulk do
          case type do
            :index -> index(index_and_type_name(model, name), data)
            :delete -> delete(index_and_type_name(model, name), data)
          end
        end

      case Tirexs.bump!(payload)._bulk({[refresh: true]}) do
        {:ok, 200, %{errors: false}} ->
          {:ok, nil}
        {:ok, 200, %{errors: true, items: items}} ->
           IO.inspect items
           {:error, items}
      end

    end)
    |> Stream.run
  end

  defp index_and_type_name(model, name) do
    [type: model.estype, index: model.esindex(name)]
  end

  defp index_name(records) when is_list(records) do
    Es.Index.name_index(List.first(records).__struct__)
  end

  defp index_name(model) do
    Es.Index.name_index(model.__struct__)
  end

end
