defmodule Customer.Web.Query.JobTechKeyword do
  use Customer.Query, model: Customer.Web.JobTechKeyword
  alias Customer.Web.JobTechKeyword

  def with_job_id(repo, job_id) do
    Repo.all(with_job_id(job_id))
  end

  def with_job_id_except_tech_keyword_ids(repo, tech_keyword_ids, job_id) do
    Repo.all(
      from j in with_job_id(job_id),
      where: not j.tech_keyword_id in ^tech_keyword_ids
    )
  end

  defp with_job_id(job_id) do
    from j in JobTechKeyword,
    where: j.job_id == ^ job_id
  end

end
