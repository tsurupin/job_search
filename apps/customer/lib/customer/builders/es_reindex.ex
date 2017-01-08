defmodule Customer.Builders.EsReindex do

  @models [:tech_keyword, :job]
  def perform do
    #
      Enum.each(@models, &(reindex(&1)))
    #end
  end

  def reindex(:tech_keyword), do: reindex Customer.TechKeyword
  def reindex(:job), do: reindex Customer.Job
  def reindex(model), do: model.es_reindex
  def reindex(model) when is_nil(model), do: IO.inspect "nil"

end
