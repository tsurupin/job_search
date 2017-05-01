#defmodule Customer.Web.Query.JobTechKeyword do
#  use Customer.Query, model: Customer.Web.JobTechKeyword
#  alias Customer.Web.JobTechKeyword
#
#
#  def by_job_id(job_id) do
#    from(j in __MODULE__, where: j.job_id == ^ job_id)
#  end
#
#  def by_job_id_except_tech_keyword_ids(tech_keyword_ids, job_id) do
#    from(j in by_job_id(job_id), where: not j.tech_keyword_id in ^tech_keyword_ids)
#  end
#
#end
