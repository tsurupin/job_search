defmodule Customer.Web.Query.JobSourceTechKeyword do
  use Customer.Query, model: Customer.Web.JobSourceTechKeyword
  alias Customer.Web.JobSourceTechKeyword

  def tech_keyword_ids_by(repo, job_source_id) do
    tech_keyword_ids_by(job_source_id)
    |> repo.all
  end

  def by_job_source_id_except_tech_keyword_ids(tech_keyword_ids, job_source_id) do
    from j in JobSourceTechKeyword,
    where: not j.tech_keyword_id in ^tech_keyword_ids and j.job_source_id == ^job_source_id
  end

  defp tech_keyword_ids_by(job_source_id) do
      from j in JobSourceTechKeyword,
      where: j.job_source_id == ^job_source_id,
      select: j.tech_keyword_id
   end

end
