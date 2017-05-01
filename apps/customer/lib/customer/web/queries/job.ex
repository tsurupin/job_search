#defmodule Customer.Web.Query.Job do
#  use Customer.Query, model: Customer.Web.Job
#  alias Customer.Web.Job
#
#def get_with_associations(id) do
#    Job.get(id)
#    |> first
#    |> Repo.one
#  end
#
#  def by_company_id(company_id) do
#    Job.by_company_id(company_id)
#    |> Repo.all
#  end
#
#  def get(id) do
#      from(j in __MODULE__, where: j.id == ^id, preload: [:area, :company, :tech_keywords, :job_title])
#    end
#
#    def by_company_id(company_id) do
#      from(j in __MODULE__, where: j.company_id == ^company_id, preload: [:area, :job_title])
#    end
#
#    def query_all(:index) do
#      from j in __MODULE__,
#      preload: [:area, :company, :tech_keywords, :job_title]
#    end
#
#
#end
