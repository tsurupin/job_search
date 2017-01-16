defmodule Customer.Es.Filter.Job do
  import Tirexs.Query
  import Tirexs.Search
  require Tirexs.Query.Filter

  def perform(params) do
    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "job_title", es_terms(params[:job_title])
          terms "area_name", es_terms(params[:area_name])
          terms "techs",    es_terms(techs(params[:techs]))
          terms "detail", es_terms(params[:detail])
        end
      end
    end
    |> Keyword.get(:filter)
  end

  defp techs(values) when is_nil(values), do: [true, false]
  defp techs(values) do
    values
    |> String.split(",")
    |> Enum.map(&(String.trim(&1)))
  end

  defp es_terms(value) when is_nil(value), do: [true, false]
  defp es_terms(value), do: [value]
  defp es_terms(values) when is_list(values), do: downcase(values)

  defp downcase(values) when is_list(values) do
    Enum.map(values, &(downcase(&1)))
  end

  defp downcase(value), do: String.downcase(value)

end
