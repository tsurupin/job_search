defmodule Customer.Web.Query.JobTechKeyword do
  use Customer.Query, model: Customer.Web.JobTechKeyword
  alias Customer.Web.JobTechKeyword

  def all_by_job_id(repo, job_id) do
    repo.all(by_job_id(job_id))
  end

  def by_job_id_except_tech_keyword_ids(job_id, tech_keyword_ids) do
    by_job_id(job_id)
    |> except_tech_keyword_ids(tech_keyword_ids)
  end

  defp by_job_id(query \\ JobTechKeyword, job_id) do
    from j in query,
    where: j.job_id == ^job_id
  end

  defp except_tech_keyword_ids(query \\ JobTechKeyword, tech_keyword_ids) do
    from j in query,
    where: not j.tech_keyword_id in ^tech_keyword_ids
  end

end
