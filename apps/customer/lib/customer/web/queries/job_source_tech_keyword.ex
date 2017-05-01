#defmodule Customer.Web.Query.JobSourceTechKeyword do
#  use Customer.Query, model: Customer.Web.JobSourceTechKeyword
#  alias Customer.Web.JobSourceTechKeyword
#
#  def tech_keyword_ids_by(job_source_id) do
#    JobSourceTechKeyword.by_tech_keyword_ids(job_source_id)
#    |> Repo.all
#  end
#
#  defp by_tech_keyword_ids(job_source_id) do
#      from(j in __MODULE__,
#        where: j.job_source_id == ^job_source_id,
#        select: j.tech_keyword_id
#      )
#    end
#
#    defp by_source_id_except_tech_keyword_ids(tech_keyword_ids, source_id) do
#      from j in __MODULE__,
#      where: not j.tech_keyword_id in ^tech_keyword_ids and j.job_source_id == ^source_id
#    end
#end
