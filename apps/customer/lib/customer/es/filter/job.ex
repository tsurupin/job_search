defmodule Customer.Es.Filter.Job do
  import Tirexs.Query
  import Tirexs.Search
  require Tirexs.Query.Filter

  def perform(params) do
    techs = params[:techs] || [true, false]

    Tirexs.Query.Filter.filter do
      bool do
        must do
          terms "job_title", es_terms(params[:job_title])
          terms "area_name", es_terms(params[:area_name])
          terms "techs",    es_terms(params[:techs])
          terms "detail", es_terms(params[:detail])
        end
      end
    end
    |> Keyword.get(:filter)
  end

  defp es_terms(value) when is_nil(value), do: [true, false]
  defp es_terms(value) when is_list(value), do: value
  defp es_terms(value), do: [value]

end
