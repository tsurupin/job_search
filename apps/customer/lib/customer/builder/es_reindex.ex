defmodule Customer.Builder.EsReindex do

  @models [:tech_keyword, :job]
  def perform do
    Enum.each(@models, &(reindex(&1)))
  end

  def reindex(:tech_keyword), do: reindex Customer.Web.TechKeyword
  def reindex(:job), do: reindex Customer.Web.Job
  def reindex(model) when is_nil(model), do: IO.inspect "nil"
  def reindex(model), do: model.es_reindex

end
